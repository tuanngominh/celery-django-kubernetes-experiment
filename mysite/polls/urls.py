from django.urls import include, path
from rest_framework.routers import DefaultRouter

from .viewsets import PostViewSet

router = DefaultRouter()
router.register("", PostViewSet, "posts")

urlpatterns = [path("", include(router.urls))]
