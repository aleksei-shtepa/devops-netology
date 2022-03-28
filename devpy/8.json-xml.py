from base64 import encode
import xml.etree.ElementTree as ET
import json
from collections import Counter


def from_json():
    with open("newsafr.json", "r") as f:
        rss = json.load(f)
    word_amount = Counter()
    for record in rss['rss']['channel']['items']:
        word_amount += Counter([word.lower() for word in record['description'].split() if len(word) > 6])
    # print(word_amount.most_common(10))
    for word, amount in word_amount.most_common(10):
        print(f"{word}: {amount}")


def from_xml():
    parser = ET.XMLParser(encoding="utf-8")
    tree = ET.parse("newsafr.xml", parser)
    root = tree.getroot()
    xml_items = root.findall("channel/item")
    
    word_amount = Counter()
    for xmli in xml_items:
        word_amount += Counter([word.lower() for word in xmli.find("description").text.split() if len(word) > 6])

    for word, amount in word_amount.most_common(10):
        print(f"{word}: {amount}")
        

if __name__ == "__main__":
    from_json()
    # from_xml()
