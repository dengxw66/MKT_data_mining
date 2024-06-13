import csv
from playwright.sync_api import sync_playwright
from bs4 import BeautifulSoup
import pandas as pd
from tqdm import tqdm
from PIL import Image
from io import BytesIO
import requests
import os,re
import time,datetime

def scroll_to_bottom(page):
    print("scroll start")
    previous_scroll_height = page.evaluate("document.body.scrollHeight")
    page.evaluate("window.scrollTo(0, document.body.scrollHeight-200)")
    page.wait_for_timeout(2000)
    print("scroll done")



def contains_any_keyword(text, keywords):
    for keyword in keywords:
        if keyword in text:
            return True
    return False

def download_video_img(poster_id, post_id, url, filename):
    path = 'D:/Python/SCGC/redbook/outputs/' + poster_id + '/' + post_id
    if not os.path.exists(path):
        os.makedirs(path)
    url = url.replace('\\u002F', '/')
    try:
        r = requests.get(url, allow_redirects=True)
        with open(path + '/' + filename, 'wb') as f:
            f.write(r.content)
        print(f"Downloaded {filename} to {path}")
    except Exception as e:
        print(f"Failed to download {filename} from {url}: {e}")

def fetch_post_data(browser,post_url,poster_id):
    #https://www.xiaohongshu.com/user/profile/5c7ddd57000000001003c005/665a743c0000000015008ef9
    global start_date,end_date,target_poster
    match = re.search(r'[^/]+/([^/]+)$', post_url)
    if match:
        post_id = match.group(1)
    else:
        match = re.search(r'/explore/(.*)', post_url)
        if match:
            post_id = match.group(1)
        else:
            return None

    page = browser.new_page()
    page.set_default_timeout(0)  

    def create_intercept_request(poster_id,post_id,video_file):
        def intercept_request(route, request):
            if "sns-video" in request.url:  
                download_video_img(poster_id,post_id, request.url,video_file)
            route.continue_()
        return intercept_request

    video_file = 'video.mp4'
    page.route("**/*", create_intercept_request(poster_id,post_id,video_file))
    page.goto(post_url)
    page.wait_for_timeout(2000)

    html_content = page.content()
    soup = BeautifulSoup(html_content, 'html.parser')

    try:
        post_date = soup.find('span', class_='date').get_text()
        if post_date:
            [post_date, post_location] = post_date.split(' ')
        else:
            post_date = ""
            post_location = ""
    except:
        post_date = ""
        post_location = ""    
    try:
        post_time = soup.find('div', class_='date').find('span').get_text()
        if post_time:
            try:
                [_, post_time] = post_time.split(' ')
            except:
                post_time = ""
        else:
            post_time = ""
    except:
        post_time = ""
    
    if_go_next = True
    retry_times = 3
    while if_go_next:
        try:
            post_title = soup.find('meta', {'name': 'og:title'}).get('content')
            post_content = soup.find('meta', {'name': 'description'}).get('content')
            post_tag = soup.find('meta', {'name': 'keywords'}).get('content')
            post_comments = soup.find('meta', {'name': 'og:xhs:note_comment'}).get('content')
            post_like = soup.find('meta', {'name': 'og:xhs:note_like'}).get('content')
            post_collect = soup.find('meta', {'name': 'og:xhs:note_collect'}).get('content')
            post_img = soup.find('meta', {'name': 'og:image'}).get('content')
            comments = soup.find_all('div', class_='content')
            if_go_next = False
        except:
            page.wait_for_timeout(2000)
            retry_times = retry_times-1

        if retry_times == 0:
            if_go_next = False
            page.close()
            return True
    comment_array = []
    if comments:
        for com in comments[:10]:
            tmp = com.get_text()
            comment_array.append(tmp)
        post_comment_content = ('##').join(comment_array)
    else:
        post_comment_content = ''           

    download_video_img(poster_id,post_id, post_img,'post.png')
    post_fetch_time = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    data = {
        'poster_id': poster_id,
        'post_id':post_id,
        'post_url': post_url,
        'post_title': post_title,
        'post_location': post_location,
        'post_date': post_date,
        'post_time': post_time,
        'post_content': post_content,
        'post_tag': post_tag,
        'post_comments': post_comments,
        'post_like': post_like,
        'post_collect': post_collect,
        'post_img': post_img,
        'post_comment_content': post_comment_content,
        'post_fetch_time': post_fetch_time
    }
    post_datetime = datetime.datetime.strptime(post_date, '%Y-%m-%d')
    start_datetime = datetime.datetime.strptime(start_date, '%Y-%m-%d')
    end_datetime = datetime.datetime.strptime(end_date, '%Y-%m-%d')   
    
    if( start_datetime <= post_datetime <= end_datetime ):
        df = pd.DataFrame([data])
        csv_file = '01post_data_'+datetime.datetime.now().strftime("%Y-%m-%d")+'.csv'
        df.to_csv(csv_file, mode='a', header=not pd.io.common.file_exists(csv_file), index=False)

    else:
        df = pd.DataFrame([data])
        csv_file = '01post_data_all_'+datetime.datetime.now().strftime("%Y-%m-%d")+'.csv'
        df.to_csv(csv_file, mode='a', header=not pd.io.common.file_exists(csv_file), index=False)


    page.close()
    if post_datetime <= start_datetime:
        return False
    else:
        return True

def fetch_poster_data(browser,page,profile_url):
    #profile_url = f'https://www.xiaohongshu.com/user/profile/{poster_id}'
    match = re.search(r'profile/([^/]+)', profile_url)
    if match:
        poster_id = match.group(1)  # 获取匹配的参数
    else:
        return None
    print(poster_id)
    page.goto(profile_url)

    html_content = page.content()
    soup = BeautifulSoup(html_content, 'html.parser')

    ip = soup.find('span', class_='user-IP').get_text()
    if ip:
        poster_ip = ip.replace(' IP属地：','')
    else:
        poster_ip = ''
    poster_name = soup.find('div', class_='user-name').get_text()
    poster_desc = soup.find('div', class_='user-desc').get_text()
    poster_gender = soup.find('div', class_='gender').find('use').get('xlink:href')

    watch_fan_fav = soup.find_all('span', class_='count')
    if watch_fan_fav:
        poster_watch = watch_fan_fav[0].get_text()
        poster_fan = watch_fan_fav[1].get_text()
        poster_fav = watch_fan_fav[2].get_text()
    else:
        poster_watch = '0'
        poster_fan = '0'
        poster_fav = '0'

    if_continue = True
    posts_feched_list = []
    last_posts = []
    while if_continue:
        scroll_to_bottom(page)
        html_content = page.content()
        soup = BeautifulSoup(html_content, 'html.parser')       
        posts = soup.find_all('a', class_='cover ld mask')
        if posts == last_posts:
            break
        else:
            last_posts = posts
            for post in posts:
                if post.get('href') not in posts_feched_list:
                    posts_feched_list.append(post.get('href'))
                    post_url = 'https://www.xiaohongshu.com'+post.get('href')
                    if_continue = fetch_post_data(browser,post_url,poster_id)
                    print(if_continue)
                    if if_continue == False:
                        break
                if if_continue == False:
                    break
        

    # 保存当前进度
    with open('01progress.txt', 'w') as f:
        f.write(str(start_idx + idx + 1))



if __name__ == "__main__":
    start_date = '2023-06-06'
    end_date = '2024-06-06'
    target_poster = []
    # 读取CSV文件，假设第一列是poster ID
    data = []
    with open('D:/Python/SCGC/redbook/test.csv', 'r') as csvfile:
        reader = csv.reader(csvfile)
        next(reader)  # 跳过标题行
        poster_ids = [row for row in reader]  # 获取全部poster IDs

    # 读取进度标记文件
    start_idx = 0
    if os.path.exists('D:/Python/SCGC/redbook/03progress.txt'):
        with open('D:/Python/SCGC/redbook/03progress.txt', 'r') as f:
            start_idx = int(f.read().strip())


    playwright = sync_playwright().start()
    firefox = playwright.firefox
    profile_path = 'D:/Python/SCGC/firefox'
    browser = firefox.launch_persistent_context(profile_path, headless=True)	
    page = browser.new_page()
    page.set_default_timeout(0)

    for idx, row in tqdm(enumerate(poster_ids[start_idx:]), total=len(poster_ids[start_idx:]), desc="Processing posters"):
        try:
            poster_id = row[1]
            fetch_poster_data(browser,page,poster_id)
        except Exception as e:
            print(f"An error occurred: {e}")
            continue

    browser.close()

