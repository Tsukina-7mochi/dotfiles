import { test, expect, mock } from 'claude-code/testing'

const MINUTE = 60 * 1000

const turn = { answer: 'ok', durationMs: 1, isAborted: false, turnId: 't', reason: 'answer' } as const

test('compacts after 50 idle minutes', async ($, on) => {
  const clock = mock.clock(on)
  const compacts: string[] = []
  on('session.compact', () => {
    compacts.push('called')
    return { skip: 'test' }
  })
  on('turn.complete', () => ({ text: 'ok' }))

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

  await $.turn.complete({ ...turn, agentId: 'a1' })
  await clock.advance(60 * MINUTE)
  expect(compacts.length).toBe(0)
})
