import requests


def main():
    response = requests.get("https://3fct.c.time4vps.cloud/help")

    print(response.ok, response.text)


if __name__ == "__main__":
    main()
