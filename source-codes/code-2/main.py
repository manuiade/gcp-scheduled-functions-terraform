import os

KEY=os.getenv("KEY")

def hello_world_schedule_2(request):
    print("Hello schedule 2 {}".format(KEY))
    return "Bye"