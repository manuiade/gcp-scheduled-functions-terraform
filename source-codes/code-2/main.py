import os

KEY=os.getenv("KEY")
SECRET_1 = os.getenv("_SECRET_1")
SECRET_2 = os.getenv("_SECRET_2")

def hello_world_schedule_2(request):
    print("Hello schedule 2 {}".format(KEY))
    print("Secret 1 is {}".format(SECRET_1))
    print("Secret 2 is {}".format(SECRET_2))
    return "Bye"