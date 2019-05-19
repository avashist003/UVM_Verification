// wall time logic for testbench //

#include<stdio.h>
#include<time.h>
#include<svdpi.h>

int sim_start_time()
{
  time_t start_time;

  start_time = time(NULL);

  return start_time;
}


void start_day_date()
{
  time_t rawtime;
  struct tm *info;

  time( &rawtime);

  info = localtime( &rawtime);
  printf("Current local time and date: %s\n", asctime(info));
}


void digit_gen_time(int n)
{
  int hour, day, min, sec;

  day = n / (24*3600);
  n = n % (24*3600);
  hour = n / 3600;
  n = n % 3600;
  min = n / 60;
  n = n % 60;
  sec = n;

  printf("%0d: %0d: %0d: %0d \n", day, hour, min, sec);

}
