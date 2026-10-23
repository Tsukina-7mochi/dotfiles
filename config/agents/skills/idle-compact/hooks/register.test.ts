import type { SessionUsage } from 'claude-code'
import { test, expect, mock } from 'claude-code/testing'

const MINUTE = 60 * 1000

const usage = (tokens?: number) => () => ({
  value: {
    startedAt: 0,
    context: tokens === undefined ? { window: 200_000 } : { window: 200_000, tokens, percent: Math.round(tokens / 2_000) },
    rateLimits: [],
  } satisfies SessionUsage,
})

const turn = { answer: 'ok', durationMs: 1, isAborted: false, turnId: 't', reason: 'answer' } as const

test('compacts after 50 idle minutes', async ($, on) => {
  const clock = mock.clock(on)
  const compacts: string[] = []
  on('session.compact', () => {
    compacts.push('called')
    return { skip: 'test' }
  })
  on('turn.complete', () => ({ text: 'ok' }))
  on('session.usage', usage(100_000))

  await $.turn.complete(turn)
  await clock.advance(49 * MINUTE)
  expect(compacts.length).toBe(0)
  await clock.advance(1 * MINUTE)
  expect(compacts.length).toBe(1)
})

test('user input resets the idle timer', async ($, on) => {
  const clock = mock.clock(on)
  const compacts: string[] = []
  on('session.compact', () => {
    compacts.push('called')
    return { skip: 'test' }
  })
  on('turn.complete', () => ({ text: 'ok' }))
  on('session.usage', usage(100_000))
  on('prompt.submit', ($, e) => ({ text: e.text }))

  await $.turn.complete(turn)
  await clock.advance(40 * MINUTE)
  await $.prompt.submit({ text: 'hi', wait: false, origin: { kind: 'composer' } })
  await clock.advance(20 * MINUTE)
  expect(compacts.length).toBe(0)
})

test('subagent turns do not arm the timer', async ($, on) => {
  const clock = mock.clock(on)
  const compacts: string[] = []
  on('session.compact', () => {
    compacts.push('called')
    return { skip: 'test' }
  })
  on('turn.complete', () => ({ text: 'ok' }))
  on('session.usage', usage(100_000))

  await $.turn.complete({ ...turn, agentId: 'a1' })
  await clock.advance(60 * MINUTE)
  expect(compacts.length).toBe(0)
})

test('low context usage skips compaction', async ($, on) => {
  const clock = mock.clock(on)
  const compacts: string[] = []
  on('session.compact', () => {
    compacts.push('called')
    return { skip: 'test' }
  })
  on('turn.complete', () => ({ text: 'ok' }))
  on('session.usage', usage(29_999))

  await $.turn.complete(turn)
  await clock.advance(60 * MINUTE)
  expect(compacts.length).toBe(0)
})

test('unknown context usage skips compaction', async ($, on) => {
  const clock = mock.clock(on)
  const compacts: string[] = []
  on('session.compact', () => {
    compacts.push('called')
    return { skip: 'test' }
  })
  on('turn.complete', () => ({ text: 'ok' }))
  on('session.usage', usage())

  await $.turn.complete(turn)
  await clock.advance(60 * MINUTE)
  expect(compacts.length).toBe(0)
})
