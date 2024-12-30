from rest_framework.pagination import PageNumberPagination

class minPage(PageNumberPagination):
    page_size=3
    
class largePage(PageNumberPagination):
    page_size=7