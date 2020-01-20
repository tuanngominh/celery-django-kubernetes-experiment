from celery import group, chain, chord

from tasks import add, mul, xsum, report_error

# raise exception still can run
# res = (
#     group(
#         (add.s(4, 4) | mul.s(2)), # 16
#         (add.s(5, 4) | mul.s(3)), # 27
#         (add.s(5, 5) | mul.s(4))  # 40
#     )
#     | xsum.s() # 83
# )
# res.apply_async()

# raise exception still can run, and call handle error function
res = (
    group(
        (add.s(4, 4) | mul.s(2)), # 16
        (add.s(5, 4) | mul.s(3)), # 27
        (add.s(5, 5) | mul.s(4))  # 40
    )
    | xsum.s() # 83
)
res.apply_async(link_error=report_error())


# raise exception then it's run forever
# res = (
#     group(
#         (add.s(4, 4) | mul.s(2)), # 16
#         (add.s(5, 4) | mul.s(3)), # 27
#         (add.s(5, 5) | mul.s(4))  # 40
#     )
#     | xsum.s() # 83
# )
# res().get()
