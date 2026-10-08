export type Line = {
  model: string
  effort?: string | number
  dir?: string
  branch?: string
  context: number
  fiveHour: number
  sevenDay: number
}

declare module 'claude-code' {
  interface PluginState {
    statusline: { line: Line }
  }
}
