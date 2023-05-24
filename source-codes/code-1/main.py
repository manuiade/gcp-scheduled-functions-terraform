import os

KEY=os.getenv("KEY")

def hello_world_schedule_1(request):
    print("Hello schedule 1 {}".format(KEY))
    return "Bye"