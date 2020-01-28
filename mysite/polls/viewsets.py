from celery import group
from rest_framework.viewsets import ModelViewSet
from .tasks import add, mul, xsum, report_error, save_to_post
from .models import Post
from .serializers import PostSerializer


class PostViewSet(ModelViewSet):
    serializer_class = PostSerializer
    queryset = Post.objects.all()

    def perform_create(self, serializer):
        super().perform_create(serializer)

        res = (
            group(
                (add.s(4, 4) | mul.s(2)),  # 16
                (add.s(5, 4) | mul.s(3)),  # 27
                (add.s(5, 5) | mul.s(4))  # 40
            )
            | xsum.s()  # 83
            | save_to_post.s(serializer.data['id'])
        )
        res.apply_async(link_error=report_error())

