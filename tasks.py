from celery import Celery

# app = Celery('tasks', broker='redis://redis:6379/0')
app = Celery('tasks', broker='redis://redis:6379/0', backend='redis://redis:6379/0')


@app.task()
def add(x, y):
    if x == 4:
        raise Exception("Found 4")
    return x + y


@app.task()
def mul(x, y):
    return x*y


@app.task()
def xsum(numbers):
    return sum(numbers)


@app.task()
def report_error(*args):
    print("report_error start")
    print(args)
    print("report_error end")
