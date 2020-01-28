from celery import shared_task
from .models import Post


@shared_task
def add(x, y):
    # if x == 4:
    #     raise Exception("Found 4")
    return x + y


@shared_task
def mul(x, y):
    return x*y


@shared_task
def xsum(numbers):
    return sum(numbers)


@shared_task
def report_error(*args):
    print("report_error start")
    print(args)
    print("report_error end")


@shared_task
def save_to_post(result, post_id):
    post = Post.objects.get(pk=post_id)
    post.content = result
    post.save()
