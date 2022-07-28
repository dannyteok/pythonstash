import bs4, requests

def ipaddr(url):
    res = requests.get(url)
    res.raise_for_status()
    soup = bs4.BeautifulSoup(res.text,"html.parser")
    elems = soup.select("body > main:nth-child(1) > div:nth-child(1) > h1:nth-child(1)")
    return elems[0].text.strip()

ipis = ipaddr("https://ipecho.net/")
ISOLATE_IP = ipis.split(" ")[-1]
print(f"Your global IP is {ISOLATE_IP}")



# res = requests.get("https://ipecho.net/")
# res.raise_for_status()
# soup = bs4.BeautifulSoup(res.text, "html.parser")
# elems = soup.select("body > main:nth-child(1) > div:nth-child(1) > span:nth-child(3)")
# # print(elems[0].text.split())
# # print("*"*20)
# elems_new = ""
# for strx in elems[0].text.split()[:-2]:   # discard 'Try IPInfo.io'
#     elems_new += str(strx) + " "
# print(elems_new)