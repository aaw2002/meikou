import { BreakpointConstants } from "../constants/BreakpointConstants"

// common/breakpointSystem.ets
export  interface BreakPointTypeOption<T> {
  xs?: T
  sm?: T
  md?: T
  lg?: T
}
export const BreakPointKey:string='currentBreakpoint'
  export class BreakPointType<T> {
  options: BreakPointTypeOption<T>

  constructor(option: BreakPointTypeOption<T>) {
    this.options = option
  }

  getValue(currentBreakPoint: string) {
    if (currentBreakPoint === BreakpointConstants.XS) {
      return this.options.xs
    } else if (currentBreakPoint === BreakpointConstants.SM) {
      return this.options.sm
    } else if (currentBreakPoint ===BreakpointConstants.MD ) {
      return this.options.md
    } else if (currentBreakPoint === BreakpointConstants.LG) {
      return this.options.lg
    } else {
      return undefined
    }
  }
}