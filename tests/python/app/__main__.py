import logging

from retry_requests import retry

ipsvc = "https://api.ipify.org?format=json"

if __name__ == '__main__':
    http = retry()
    res = http.get(ipsvc)
    if not res.ok:
        logging.error("Error calling service:" + res.status)
    print(res.json())
