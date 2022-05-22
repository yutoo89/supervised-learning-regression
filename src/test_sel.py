# pip install -U selenium
# pip install webdriver_manager

from selenium import webdriver
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.chrome.options import Options
# ブラウザの立ち上げ
# ChromeDriverManagerでchromeのバージョンに合ったdriverをインストールする
driver = ChromeDriverManager().install()
# driver
options = Options()
options.add_argument('--headless')
options.add_argument('--no-sandbox')
options.add_argument('--disable-dev-shm-usage')
browser = webdriver.Chrome(driver, options=options)
