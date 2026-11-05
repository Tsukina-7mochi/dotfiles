import type { Register } from 'claude-code'

export const register: Register = on => {
  on('prompt.submit', async ($, e, next) => {
    const language = await $.settings.read({ key: 'language' })
    if (typeof language !== 'string' || language === '' || e.command) {
      return next(e)
    }

    const reminder = `"language": "${language}" — Always respond in ${language}.`
    return next({ ...e, context: [...(e.context ?? []), reminder] })
  }).catch(($, e, next) => next(e))
}
