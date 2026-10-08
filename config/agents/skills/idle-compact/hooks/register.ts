import type { Register, Timer } from 'claude-code'

const IDLE_MS = 50 * 60 * 1000

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
    timer = $.clock.after(IDLE_MS, () => {
      timer = undefined
      $.session
        .compact()
        .then(() => $.ui.toast('idle-compact: compacted after 50 minutes idle'))
        .catch(() => undefined)
    })

    return result
  })
}
