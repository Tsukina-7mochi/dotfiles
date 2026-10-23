import type { Register, Timer } from 'claude-code'

const IDLE_MS = 50 * 60 * 1000
const MIN_CONTEXT_TOKENS = 30_000

export const register: Register = on => {
  let timer: Timer | undefined

  const cancel = () => {
    timer?.cancel()
    timer = undefined
  }

  on('prompt.submit', ($, e, next) => {
    cancel()
    return next(e)
  }).catch(($, e, next) => next(e))

  on('turn.complete', async ($, e, next) => {
    const result = await next(e)
    if (e.agentId !== undefined) return result

    cancel()
    timer = $.clock.after(IDLE_MS, async () => {
      timer = undefined
      try {
        const { context } = await $.session.usage()
        if ((context.tokens ?? 0) < MIN_CONTEXT_TOKENS) return
        await $.session.compact()
        $.ui.toast(`idle-compact: compacted after 50 minutes idle (context ${context.tokens} tokens)`)
      } catch {
        // ignore
      }
    })

    return result
  })
}
