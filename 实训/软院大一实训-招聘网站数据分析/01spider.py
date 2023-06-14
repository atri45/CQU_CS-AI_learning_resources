import time
import requests
#-----------------------------------------------获取页面信息--------------------------------------------------------------
def askURL(url,i):
    #加入headers反爬
    headers = {
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
    "Accept-Encoding": "gzip, deflate, br",
    "Accept-Language": "en-GB,en-US;q=0.9,en;q=0.8",
    "Cache-Control": "max-age=0",
    "Connection": "keep-alive",
    "Cookie": "_uab_collina=166106821143997136464303; acw_tc=ac11000116610682118946662e00de009c2f2bd14b8a257d651ef93a4606fc; acw_sc__v3=6301e3b5ed12fa8438b7669c6d0156588a3420b3; guid=6ee4bc2284fe372cd0c269c862930214; nsearch=jobarea%3D%26%7C%26ord_field%3D%26%7C%26recentSearch0%3D%26%7C%26recentSearch1%3D%26%7C%26recentSearch2%3D%26%7C%26recentSearch3%3D%26%7C%26recentSearch4%3D%26%7C%26collapse_expansion%3D; search=jobarea%7E%60000000%7C%21ord_field%7E%600%7C%21recentSearch0%7E%60000000%A1%FB%A1%FA000000%A1%FB%A1%FA0000%A1%FB%A1%FA00%A1%FB%A1%FA99%A1%FB%A1%FA%A1%FB%A1%FA99%A1%FB%A1%FA99%A1%FB%A1%FA99%A1%FB%A1%FA99%A1%FB%A1%FA9%A1%FB%A1%FA99%A1%FB%A1%FA%A1%FB%A1%FA0%A1%FB%A1%FA%A1%FB%A1%FA2%A1%FB%A1%FA1%7C%21; sajssdk_2015_cross_new_user=1; sensorsdata2015jssdkcross=%7B%22distinct_id%22%3A%226ee4bc2284fe372cd0c269c862930214%22%2C%22first_id%22%3A%22182bf6181df114a-028409d5286253a-26021d51-1327104-182bf6181e010fb%22%2C%22props%22%3A%7B%22%24latest_traffic_source_type%22%3A%22%E7%9B%B4%E6%8E%A5%E6%B5%81%E9%87%8F%22%2C%22%24latest_search_keyword%22%3A%22%E6%9C%AA%E5%8F%96%E5%88%B0%E5%80%BC_%E7%9B%B4%E6%8E%A5%E6%89%93%E5%BC%80%22%2C%22%24latest_referrer%22%3A%22%22%7D%2C%22identities%22%3A%22eyIkaWRlbnRpdHlfY29va2llX2lkIjoiMTgyYmY2MTgxZGYxMTRhLTAyODQwOWQ1Mjg2MjUzYS0yNjAyMWQ1MS0xMzI3MTA0LTE4MmJmNjE4MWUwMTBmYiIsIiRpZGVudGl0eV9sb2dpbl9pZCI6IjZlZTRiYzIyODRmZTM3MmNkMGMyNjljODYyOTMwMjE0In0%3D%22%2C%22history_login_id%22%3A%7B%22name%22%3A%22%24identity_login_id%22%2C%22value%22%3A%226ee4bc2284fe372cd0c269c862930214%22%7D%2C%22%24device_id%22%3A%22182bf6181df114a-028409d5286253a-26021d51-1327104-182bf6181e010fb%22%7D; ssxmod_itna=Yu0=Dv4GgGCWP0dD=G7+aG=gf3sKDIojEqqAKE3D/ftwD3q0=GFDt4iAYSEqExPqbp7afiA4pOchQT8EYnhadmF=RdDHxY=OhKGoTeDxx0okD74irDDxD3DbbKDSGxG=DjjttZS6xYPDEA5DREPDuZvGDGPQLOuGDeKD0xD88x07KUKDeEcG0CEChjOPajKD9OYDs1+f3jImL9f4g6gAp4B39D0kM40Occ7CH4GdU6v1DK2Dt2CeVC0a6ebPtQxW=6CKhCRD=eRcX72KFYnoTG2ufLDDic2PsahDD===; ssxmod_itna2=Yu0=Dv4GgGCWP0dD=G7+aG=gf3sKDIojEqqAKPG9WNdKDBdwe7p0EQSfI5B38D6QiHx7hAEGF37vifdqjhVfWlBe+QE1DkU3Th3a8rE=EKayr=09SPk5pUdelfS3HxbX7umIx/dgehDwstg4QorAY5KnW3jYhhBY+VWnmNgTib=xIeFvTqnDIoxKw8PuNDpFrAtc7p89r41grlEHIHzv7/G8zReWOio5iRO91pan1ZRSpqcgfszDvVeZRTlCf7hYki2ffvgvUyExF2UqUQ9apQ9MmEV7Pb2=wcSumnkrI2kmB=GcD=g5+26/PiyYUwgw7cXSnQ+am6G5R1dunQZOouGfnBYlCm6Cw3QAYEp6PRsnDXpfmGDjBvCe4ZcEjEqkjEwQezCK1=PV=2femnDPwhPDbb2opAatZh35RoZpxgQGQCQPjo42vTQYAzoGnNyh=12v6zP1gvnnLFbqX8vnRRc4jxg29Sec7a+A4DQIPtDYPgxBG=trTndsv9sqrGErx8DDFqD+EDxD",
    "Host": "search.51job.com",
    "sec-ch-ua-mobile": "?0",
    "sec-ch-ua-platform": "Windows",
    "Sec-Fetch-Dest": "document",
    "Sec-Fetch-Mode": "navigate",
    "Sec-Fetch-Site": "same-origin",
    "Sec-Fetch-User": "?1",
    "Upgrade-Insecure-Requests": "1",
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36"
    }
    #加入data反爬
    data = {
        "u_atoken": "e92d45c7-6c3d-4493-a866-4b1b2b004c40",
        "u_asession": "01OEULB-yWmqhgvJ_UaG71u-Q--63se7HTe6aocNhOBRt-FWo6WMSptDNKyYgALCrTX0KNBwm7Lovlpxjd_P_q4JsKWYrT3W_NKPr8w6oU7K_1ELEc7nsCbw642ocYpX_33TYvls7v_Epik-OyKXq1TWBkFo3NEHBv0PZUm6pbxQU",
        "u_asig": "053Ral_nnvzvuiyXdeEvpB7r2TAUo3N2ROsVDJ4nDZuDsXH1xIYVk55Wad96qqzfwgZKrNqtXF6pcVfm9ZgiW_IrEWJuiuGnTMivKqX9pTzCv2k0bYCRUZPd_nPu3xkfyoNg5rDxUgoM0A_QFK9AlDNm75HcDIJP5RD3cdjEi0oPP9JS7q8ZD7Xtz2Ly-b0kmuyAKRFSVJkkdwVUnyHAIJzUtnhUPO-gesHSn7CmaEi3ysEe-wa_Su-xpzDgsaO9vYyZo170oZzfjmGNwwqqFezu3h9VXwMyh6PgyDIVSG1W8KvXcxLRUxgVegP1EUuZFJS0gA-YCVD9qXtlq4leRItEEOGjBU7WCdQJ-ekwm7hE3lMoTH8GHLtQ4qH6322j9fmWspDxyAEEo4kbsryBKb9Q",
        "u_aref": "hG/3I+kuSAFqyynBCszw8n5eJnQ=",
    }
    response = requests.get(url=url, params=data, headers=headers)
    if response.status_code == 200:  # 响应状态码等于200表示发送请求，获取响应成功
        response.encoding = 'gbk'
        print("成功爬取第{0}页".format(i))
        return response.text  # .text方法是返回HTML5文本


#--------------------------------将爬取到的页面信息写入文件------------------------------------------------------------------
def write_to_html(i,j):
    with open('./data/{job_name}{page}'.format(page=i,job_name=j), 'w', encoding='utf-8') as f:
        f.write(res)
        print("成功保存{0}第{1}页".format(j,i))
#-----------------------------------------------------------------------------------------------------------------------


if __name__ == '__main__':
    job_list=[ '人工智能','机器学习', '数据分析', '数据挖掘', '算法工程师','python','语音识别','图像处理','律师','销售']
    for j in job_list:
        for i in range(6,11):       # 爬取多页
            url = "https://search.51job.com/list/000000,000000,0000,00,9,99,{job_name},2,{page}.html".format(page=i,job_name=j)

            res = str(askURL(url,i))
            write_to_html(i,j)         #将爬取到的页面信息写入文件
            time.sleep(4.5)          #设置休眠时间反爬
        time.sleep(2.5)


#%%
