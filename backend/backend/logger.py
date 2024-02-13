import logging
import socket
from logging.handlers import SocketHandler


class CustomSocketHandler(SocketHandler):
    def __init__(self, host, port):
        super().__init__(host, port)

    def makePickle(self, record):
        pass
    
    def emit(self, record):
        s = None
        try:
            s = self.makeSocket()
            data = self.format(record).encode('utf-8')
            # if self.retry(s, data):
            #     return
            s.sendall(data)
        except Exception as e:
            self.handleError(record)
            print(f"Error occured during logging", {record})
        finally:
            if s:
                s.close()

