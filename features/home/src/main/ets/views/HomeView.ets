import { BreakPointKey } from "basic"

@Component
export struct HomeView{
  @StorageProp(BreakPointKey) curpoint: string = ''
  build() {
    Column(){
      Text('首页'+this.curpoint)
    }.width('100%')
    .height('100%')
  }
}