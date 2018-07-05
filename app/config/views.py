from django.shortcuts import render


def index(request):
    # TEMPLATE설정에 app/templates폴더 추가
    # templates폴더에 'index.html'추가

    # STATICFILES_DIRS에 app/static폴더 추가
    # static/css폴더에 Bootstrap CSS파일(css/bootstrap.css)추가

    # index.html에서 {% static %}태그를 사용해서
    # head태그 내의 link태그에 css/bootstrap.css를 불러오기

    # 임의의 이미지파일을 static/images폴더에 추가
    # 해당 이미지파일을 {% static %}태그로 본문에 삽입

    # url '/'이 이 View와 연결되도록 urls.py설정
    return render(request, 'index.html')
