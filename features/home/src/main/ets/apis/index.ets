import { axiosInstance, CategoryItem, RequestAxios, ResponseType } from "basic"
import { Banner } from "../viewmodel"

// 获取轮播图
export const getBannerList = async () => {
  return await RequestAxios.get<Banner[]>('/home/banner')
}

//获取分类列表
export const getCategoryList = async () => {
  return await RequestAxios.get<CategoryItem[]>('/home/category/head')
}