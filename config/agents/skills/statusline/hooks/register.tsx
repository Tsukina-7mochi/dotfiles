import { atom, read, update } from 'claude-code'
import type { Register, SessionRateLimit } from 'claude-code'

import type { Line } from '../types'

const LEVELS = ['⡀', '⣀', '⣄', '⣤', '⣦', '⣶', '⣷', '⣿']

export const braille = (p: number): string =>
  LEVELS[Math.min(7, Math.max(0, Math.floor((p * 7) / 100)))]

const gauge = (p: number): string => {
  const n = Math.floor(p)
  return `${n}% ${braille(n)}`
}

const limit = (limits: SessionRateLimit[], kind: string): number =>
  limits.find(l => l.kind === kind)?.percentUsed ?? 0

export const head = (l: Line): string => `[${l.model} ${l.effort ?? ''} ${gauge(l.context)}]`

export const tail = (l: Line): string =>
  [
    ...(l.dir || l.branch ? [[l.dir, l.branch].filter(Boolean).join(' ')] : []),
    `5h ${gauge(l.fiveHour)}`,
    `7d ${gauge(l.sevenDay)}`,
  ].join(' / ')

const line = atom({ plugin: 'statusline', key: 'line' } as const, {
  model: '',
  context: 0,
  fiveHour: 0,
  sevenDay: 0,
})

export const register: Register = on => {
  const gitBranch = async (
    run: (argv: string[]) => Promise<{ exitCode: number; stdout: string }>,
  ): Promise<string | undefined> => {
    const { exitCode, stdout } = await run(['git', 'symbolic-ref', '--short', 'HEAD'])
    return exitCode === 0 ? stdout.trim() : undefined
  }

  const cwdBasename = async (
    run: (argv: string[]) => Promise<{ exitCode: number; stdout: string }>,
  ): Promise<string | undefined> => {
    const { exitCode, stdout } = await run(['pwd'])
    return exitCode === 0 ? stdout.trim().split('/').pop() || '/' : undefined
  }

  on('session.start', async ($, e, next) => {
    const started = await next(e)
    const model = await $.session.model()
    const effort = (await $.settings.read()).effortLevel
    const usage = await $.session.usage()
    const branch = await gitBranch(argv => $.process.run(argv))
    const dir = await cwdBasename(argv => $.process.run(argv))
    await update($, line, l => ({
      ...l,
      model,
      effort: typeof effort === 'string' ? effort : l.effort,
      dir,
      branch,
      context: usage.context.percent ?? 0,
      fiveHour: limit(usage.rateLimits, 'five_hour'),
      sevenDay: limit(usage.rateLimits, 'seven_day'),
    }))
    return started
  })

  on('turn.step', async function* ($, e, next) {
    if (e.agentId === undefined) {
      await update($, line, l => ({ ...l, model: e.model, effort: e.effort }))
    }
    return yield* next(e)
  })

  on('session.measure', async ($, e, next) => {
    const branch = await gitBranch(argv => $.process.run(argv))
    const dir = await cwdBasename(argv => $.process.run(argv))
    await update($, line, l => ({
      ...l,
      dir,
      branch,
      context: e.context.percent ?? 0,
      fiveHour: limit(e.rateLimits, 'five_hour'),
      sevenDay: limit(e.rateLimits, 'seven_day'),
    }))
    return next(e)
  })

  on('ui.render', { component: 'AbovePrompt' }, async ($, e, next) => {
    const l = await read($, line)
    if (e.props.hasSurvey || l.model === '') return next(e)

    const { Box, Text } = $.ui.resolve(e)

    return (
      <Box>
        <Text color="claude">{head(l)} </Text>
        <Text>{tail(l)}</Text>
      </Box>
    )
  })
}
