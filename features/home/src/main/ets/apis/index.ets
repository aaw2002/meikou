import { axiosInstance, CategoryItem, MkGoodsItem, RequestAxios, ResponseType } from "basic"
import { MkGoods } from "../components/MkGoods"
import { Banner, HOtResult } from "../viewmodel"

// 获取轮播图
export const getBannerList = async () => {
  return await RequestAxios.get<Banner[]>('/home/banner')
}

//获取分类列表
export const getCategoryList = async () => {
  return await RequestAxios.get<CategoryItem[]>('/home/category/head')
}

//获取特惠推荐
export const getSaleGoods = async () => {
  return await RequestAxios.get<HOtResult>('/hot/preference')
}

//获取爆款推荐
export const getHotGoods = async () => {
  return await RequestAxios.get<HOtResult>('/hot/inVogue');
}

//获取一站买全
export const getOneGoods = async () => {
  return await RequestAxios.get<HOtResult>('/hot/oneStop')
}

//获取新鲜好物
export const getNewGoods = async () => {
  return await RequestAxios.get<MkGoodsItem[]>('/home/new',new Object({ limit: 8 }))
}

//获取推荐列表
export const getRecommendGoods = async (limit?:number) => {
  return await RequestAxios.get<MkGoodsItem[]>('/home/recommend',new  Object({
    limit:limit
  }))
}