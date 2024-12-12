import { BreakPointKey, BreakPointType, Log, MkGoodsItem, MkLoading, pageStack, PullToRefresh, SafeArea } from 'basic'
import { getSearhGoods } from '../apis'
import { MkGoods } from '../components/MkGoods'
import { GoodsItems } from '../viewmodel'

// 联合类型
export type SortField = 'publishTime' | 'orderNum' | 'price'

export type SortMethod = 'desc' | 'asc'

// 提交给服务器的参数
export interface SearchParams {
  keyword: string
  sortField: SortField
  sortMethod: SortMethod
  page: number
  pageSize: number
}

// 搜索结果
export interface SearchResult {
  pageData: GoodsItems;
}

// 筛选条件
export interface SortCompAttr {
  field: SortField
  label: string
}


// 路由参数
interface RouterParam {
  keyword: string
}


@Builder
function SearchResultBuilder() {
  NavDestination() {
    SearchResultView()
  }.hideTitleBar(true)
}

@Component
export struct SearchResultView {
  @StorageProp(BreakPointKey) curbp: string = ''
  @State isLoading: boolean = true;
  // 顶部安全区域
  @StorageProp(SafeArea.TopHeight) safeTop: number = 0
  // mock 数据
  @State data: MkGoodsItem[] = new Array(8).fill({
    "id": "4033959",
    "name": "3秒快速拆琴轻松保养odin奥丁12半音阶口琴",
    "price": 329,
    "picture": "https://yanxuan-item.nosdn.127.net/937a8e46a9284e8f7e00e13911ecfbe7.png",
    "payCount": 0
  })
  // 查询参数
  @State
  @Watch('paramsChange')
  params: SearchParams =
    {
      keyword: '',
      sortField: 'publishTime',
      sortMethod: 'desc',
      page: 1,
      pageSize: 10
    }
  // 筛选条件
  sortList: SortCompAttr[] = [
    { label: '时间', field: 'publishTime' },
    { label: '销量', field: 'orderNum' },
    { label: '价格', field: 'price' }
  ]
  // 控制器
  scroller = new Scroller()

  aboutToAppear(): void {
    // TODO 解析参数
    const keyword = pageStack.getParamByName('SearchResultView').pop() as string
    this.params.keyword = keyword
    // Log.info(keyword)
    // TODO 查询数据
    this.getSerachList()
  }

  private async getSerachList() {
    this.isLoading = true
    const res = await getSearhGoods(this.params)
    this.data = res.data.result.pageData.items
    this.isLoading = false
  }

  paramsChange() {

  }

  build() {
    if (this.isLoading) {
      LoadingProgress()
        .width(200)
    } else {

      Column() {
        // 搜索区域
        Row() {
          Image($r('[basic].media.ic_public_left'))
            .width(24)
            .aspectRatio(1)
            .fillColor($r('[basic].color.white'))
            .margin(13)
            .onClick(() => {

            })
          Search({ placeholder: '商品关键字...', value: this.params.keyword })
            .searchIcon({ src: $r('[basic].media.ic_public_search'), color: $r('[basic].color.gray') })
            .placeholderColor($r('[basic].color.gray'))
            .placeholderFont({ size: 14 })
            .backgroundColor($r('[basic].color.white'))
            .textFont({ size: 14 })
            .layoutWeight(1)
            .padding(0)
            .margin(0)
            .height(36)
            .caretStyle({ color: $r('[basic].color.red') })
            .onSubmit((value) => {
              this.params.keyword = value
              this.getSerachList()
            })
        }
        .padding({ top: this.safeTop, right: 16 })
        .linearGradient({
          angle: 135,
          colors: [[$r('[basic].color.linear_begin'), 0], [$r('[basic].color.linear_end'), 1]]
        })

        // list
        Row() {
          ForEach(this.sortList, (item: SortCompAttr) => {
            // 筛选组件
            SortItemComp({
              label: item.label,
              field: item.field,
              sortField: this.params.sortField,
              sortMethod: this.params.sortMethod,
              onCLickItem: (sortField: SortField, sortMethod: SortMethod) => {
                this.params.sortField = sortField
                this.params.sortMethod = sortMethod
                this.getSerachList()
              }
            })
          })
          Text('筛选')
            .fontSize(14)
            .fontColor($r('[basic].color.gray'))
        }
        .padding({ left: 16, right: 16 })
        .height(50)
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)

        .border({ width: { bottom: 0.5 }, color: $r('[basic].color.border') })

        PullToRefresh({
          data: $data,
          scroller: this.scroller,
          customList: () => {
            this.WaterFlowBuilder()
          },
          onRefresh: async ()=>{
           this.data=[]
             this.params.page=1
            await this.getSerachList()
            return '刷新完成'
          }
        }).layoutWeight(1)
      }
    }

  }

  @Builder
  WaterFlowBuilder() {
    WaterFlow({ scroller: this.scroller }) {
      ForEach(this.data, (item: MkGoodsItem) => {
        FlowItem() {
          MkGoods({ goods: item, smallImage: true })
        }
      })
    }
    .columnsTemplate(new BreakPointType<string>({
      sm: "1fr 1fr",
      md: "1fr 1fr 1fr",
      lg: "1fr 1fr 1fr 1fr"
    }).getValue(this.curbp))
    .columnsGap(0.5)
    .rowsGap(0.5)
    .layoutWeight(1)
  }
}

@Component
struct SortItemComp {
  // 筛选字段
  field: SortField = 'publishTime'
  // 显示的文本
  label: string = ''
  // 状态变量，接收父组件的状态属性
  // 父组件的筛选字段
  @Prop sortField: SortField = 'publishTime'
  // 父组件的排序方法
  @Prop sortMethod: SortMethod = 'desc'
  // TODO 点击筛选条件，回传  sortField 和 sortMethod 给父组件（回调函数）
  onCLickItem: (sortField: SortField, sortMethod: SortMethod) => void = () => {
  };

  build() {
    Row() {
      Text(this.label)
        .fontWeight(500)
        .fontSize(14)
        .fontColor(this.sortField === this.field ? $r('[basic].color.black') : $r('[basic].color.gray'))
      Column() {

        Image($r('[basic].media.ic_public_up'))
          .width(15)
          .height(6)
          .fillColor(this.sortField === this.field && this.sortMethod === 'asc' ? $r('[basic].color.black') :
          $r('[basic].color.gray'))
        Image($r('[basic].media.ic_public_down'))
          .width(15)
          .height(6)
          .fillColor(this.sortField === this.field && this.sortMethod === 'desc' ? $r('[basic].color.black') :
          $r('[basic].color.gray'))
      }
      .justifyContent(FlexAlign.Center)
    }
    .onClick(() => {
      if (this.field === this.sortField) {
        this.onCLickItem(this.field, this.sortMethod === 'desc' ? 'asc' : 'desc')
      } else {
        this.onCLickItem(this.field, 'desc')
      }
    })
  }
}