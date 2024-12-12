import {
  axiosInstance,
  BreakpointConstants,
  BreakPointKey,
  BreakPointType,
  Log,
  MkLoading,
  pageStack,
  ResponseType,
  SafeArea
} from 'basic'
import {
  getBannerList,
  getCategoryList,
  getHotGoods,
  getNewGoods,
  getOneGoods,
  getRecommendGoods,
  getSaleGoods
} from '../apis'
import { DiscountGoodsComp, DiscountType } from '../components/DiscountGoodsComp'
import { MkGoods } from '../components/MkGoods'
import { Banner, CategoryItem, MkGoodsItem, Params, RecommendedList } from '../viewmodel'


@Component
export struct HomeView {
  @State banners: Banner[] = []
  // 分类
  @State categories: CategoryItem[] = []
  // 特惠推荐
  @State saleGoods: MkGoodsItem[] = []
  // 爆款推荐
  @State hotGoods: MkGoodsItem[] = []
  // 一站买全
  @State oneGoods: MkGoodsItem[] = []
  // 新鲜好物
  @State newGoods: MkGoodsItem[] = []
  // 推荐商品
  // @State recommendGoods: MkGoodsItem[] = []
  @State recommendGoods: RecommendedList = new RecommendedList()
  //断点类型
  @StorageProp(BreakPointKey) curpoint: string = ''
  @StorageProp(SafeArea.TopHeight) topHeight: number = 0
  @State page: number = 1;
  @State limit: number = 10
  scroller: Scroller = new Scroller()
  @State isLoading: boolean = true
  //控制下拉刷新
  @State isRefresh: boolean = false
  //控制下拉防抖、
  @State bol: boolean = false

  aboutToAppear() {

    this.getData()
  }

  private async getData() {
    const res = getBannerList()
    const res2 = getCategoryList()
    const res1 = getSaleGoods()
    const res3 = getHotGoods()
    const res4 = getOneGoods()
    const res5 = getNewGoods()
    const res6 = getRecommendGoods(this.limit)
    Promise.allSettled([res, res2, res1, res3, res4, res5, res6])
      .then((arr) => {
        if (arr[0].status == 'fulfilled') {
          this.banners = arr[0].value.data.result
        }
        if (arr[1].status == 'fulfilled') {
          this.categories = arr[1].value.data.result
          AppStorage.setOrCreate('categories', this.categories)
        }
        if (arr[2].status == 'fulfilled') {
          this.saleGoods = arr[2].value.data.result.subTypes[0].goodsItems.items
        }
        if (arr[3].status == 'fulfilled') {
          this.hotGoods = arr[3].value.data.result.subTypes[0].goodsItems.items
        }
        if (arr[4].status == 'fulfilled') {
          this.oneGoods = arr[4].value.data.result.subTypes[0].goodsItems.items
        }
        if (arr[5].status == 'fulfilled') {
          this.newGoods = arr[5].value.data.result
        }
        //推荐
        if (arr[6].status == 'fulfilled') {
          this.recommendGoods.reloadData(arr[6].value.data.result)
        }
        //关闭加载组件
        this.isLoading = false
        //刷新完成
        if (this.bol) {
          this.isRefresh = !this.isRefresh
          this.bol = false
        }
      })
  }

  @Builder
  DiscountBuilder(params: Params) {

    Column() {
      Row({ space: 10 }) {
        Text(params.title)
          .fontColor($r('[basic].color.black'))
          .fontSize(14)
        Text(params.subTitle)
          .fontColor($r('[basic].color.text'))
          .fontSize(11)
      }
      .width('100%')
      .margin({ bottom: 10 })

      List({ space: 10 }) {
        ForEach(params.list, (item: MkGoodsItem) => {
          ListItem() {
            DiscountGoodsComp({ type: DiscountType.DISCOUNT, goods: item })
          }
        })
      }
      .width('100%')
      .height(116)
      .scrollBar(BarState.Off)
      .listDirection(Axis.Horizontal)
    }
    .height(160)
    .layoutWeight(1)
    .padding(10)
    .backgroundColor(params.bg)
    .borderRadius(8)
  }

  // 下拉刷新 Builder
  @Builder
  RefreshBuilder() {
    Row() {
      MkLoading()
    }
    .width('100%')
    .margin({ bottom: 8 })
    .justifyContent(FlexAlign.Center)
  }

  build() {
    if (this.isLoading) {
      MkLoading()
    } else {
      Refresh({ refreshing: $$this.isRefresh, builder: this.RefreshBuilder() }) {
        Scroll() {
          Column() {
            // 轮播图 + 搜索
            Stack({ alignContent: Alignment.Top }) {
              Swiper() {
                ForEach(this.banners, (item: Banner) => {
                  Image(item.imgUrl)
                    .borderRadius(10)
                })
              }
              .indicator(
                DotIndicator.dot()
                  .itemWidth(8)
                  .itemHeight(4)
                  .color('#80191919')
                  .selectedItemWidth(8)
                  .selectedItemHeight(4)
                  .selectedColor('#fc32b5f1')
              )
              .itemSpace(10)
              .displayCount(new BreakPointType<number>({
                xs: 1,
                sm: 1,
                md: 2,
                lg: 3
              }).getValue(this.curpoint))

              Row() {
                Row({ space: 4 }) {
                  Image($r('[basic].media.ic_public_search'))
                    .width(16)
                    .height(16)
                    .fillColor($r('[basic].color.white'))
                  Text('搜索...')
                    .fontSize(14)
                    .fontColor($r('[basic].color.white'))
                }
                .backgroundColor('#33191919')
                .width('100%')
                .height(40)
                .borderRadius(20)
                .padding({ left: 12 })
                .onClick(() => {
                  pageStack.pushPath({ name: 'SearchView' })
                })
              }
              .padding({ left: 16, right: 16, top: this.topHeight })
            }
            .width('100%')


            // 分类
            Column({ space: 10 }) {
              // 分类
              List({ space: 16 }) {
                ForEach(this.categories, (item: CategoryItem, index) => {
                  ListItem() {
                    Column() {
                      Image(item.picture)
                        .width(56)
                        .aspectRatio(1)
                      Text(item.name)
                        .fontSize(10)
                        .fontColor('#CC191919')
                    }
                    .width(60)
                    .height(80)
                    .borderRadius(30)
                    .clip(true)
                    .backgroundImage(item.picture)
                    .backgroundImageSize(ImageSize.Contain)
                    .backgroundImagePosition(Alignment.Center)
                    .backgroundBlurStyle(
                      BlurStyle.BACKGROUND_ULTRA_THICK,
                      { scale: 0.25 }
                    )
                  }
                })
              }
              .width('100%')
              .height(92)
              .scrollBar(BarState.Off)
              .listDirection(Axis.Horizontal)
              .alignListItem(ListItemAlign.Center)

              // 特惠推荐
              Column({ space: 10 }) {
                Image($r('app.media.home_cmd_title'))
                  .width(150)
                  .height(20)
                Row() {
                  Image($r('app.media.home_cmd_inner'))
                    .width(86)
                    .height(116)
                  List({ space: 10 }) {
                    ForEach(this.saleGoods, (item: MkGoodsItem) => {
                      ListItem() {
                        DiscountGoodsComp({ goods: item })
                      }
                    })
                  }
                  .layoutWeight(1)
                  .width('100%')
                  .height(116)
                  .backgroundColor($r('[basic].color.white'))
                  .borderRadius({
                    topRight: 8,
                    bottomRight: 8
                  })
                  .padding({ right: 10, left: 10 })
                  .scrollBar(BarState.Off)
                  .listDirection(Axis.Horizontal)
                }
              }
              .width('100%')
              .height(166)
              .backgroundImage($r('app.media.home_cmd_sm'))
              .backgroundImageSize(ImageSize.Cover)
              .borderRadius(8)
              .padding(10)
              .alignItems(HorizontalAlign.Start)

              // 爆款推荐+一站买全
              Row({ space: 10 }) {
                this.DiscountBuilder({
                  title: '爆款推荐',
                  subTitle: '最受欢迎',
                  bg: '#EDF1FB',
                  list: this.hotGoods
                })
                this.DiscountBuilder({
                  title: '一站买全',
                  subTitle: '精心优选',
                  bg: '#FCF6EA',
                  list: this.oneGoods
                })
              }

              // 新鲜好物
              Column({ space: 10 }) {
                Image($r('app.media.home_new'))
                  .width(146)
                  .height(19)
                List({ space: 10 }) {
                  ForEach(this.newGoods, (item: MkGoodsItem) => {
                    ListItem() {
                      DiscountGoodsComp({ type: DiscountType.NEW, goods: item })
                    }
                  })
                }
                .width('100%')
                .height(116)
                .scrollBar(BarState.Off)
                .listDirection(Axis.Horizontal)

              }
              .width('100%')
              .height(156)
              .padding(10)
              .backgroundColor('#F7EFF5')
              .borderRadius(8)
              .alignItems(HorizontalAlign.Start)

              // 推荐商品
              WaterFlow({ scroller: this.scroller }) {
                LazyForEach(this.recommendGoods, (item: MkGoodsItem) => {
                  FlowItem() {
                    MkGoods({ goods: item })
                  }
                })
              }
              .nestedScroll({
                scrollForward: NestedScrollMode.PARENT_FIRST,
                scrollBackward: NestedScrollMode.SELF_FIRST
              })
              .columnsTemplate(new BreakPointType<string>({
                xs: '1fr',
                sm: '1fr 1fr',
                md: '1fr 1fr 1fr',
                lg: '1fr 1fr 1fr 1fr'
              }).getValue(this.curpoint))
              .columnsGap(8)
              .rowsGap(10)
              .height('100%')
              .onReachEnd(async () => {
                AlertDialog.show({ message: this.recommendGoods.totalCount().toString() })
                await this.getmoreData()
              })

            }
            .padding({
              left: 8,
              right: 8,
              bottom: 10,
              top: 10
            })
          }
        }
        .scrollBar(BarState.Off)
        .backgroundColor(Color.White)
      }
      .onRefreshing(() => {
        if (!this.bol) {
          this.bol = true
          this.page = 1
          this.getData()
        }
      })

    }
  }

  private async getmoreData() {
    this.page++
    const res = await getRecommendGoods(this.limit * this.page)
    this.recommendGoods.pushData(res.data.result)
  }
}