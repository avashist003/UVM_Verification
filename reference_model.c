
#include <stdio.h>
#include <svdpi.h>


struct freq_max_indx{
    int max_low, max_high, low_idx, high_idx, mult_high, mult_low;
};

typedef struct freq_max_indx Struct;

// this function returns the index and loud frequency from low and high groups
Struct frequency_group(int data_in[8])
{
    Struct s;

s.mult_high = 0;
s.mult_low = 0;
s.low_idx = 0;
s.high_idx = 0;
s.mult_high = 0;
s.mult_low = 0;

    int low_freq[4];
    int high_freq[4];

    for(int i = 0; i < 4; i++)
    {
        low_freq[i] = data_in[i];
    }

    for(int j = 0; j < 4; j++)
    {
        high_freq[j] = data_in[j+4];

//printf("in data  %04x \n", data_in[4]);
//printf("in data high : %04x \n", data_in[j+4]);

    }

//printf("\n--high---- %04x\n", high_freq[0]);

    // max and index
    s.low_idx = 0;

    s.max_low = low_freq[0];
    for(int k = 0; k < 4; k++)
    {
        if(low_freq[k] > s.max_low)
        {
            s.max_low = low_freq[k];
            s.low_idx = k;
        }
    }

    // max and index
    s.high_idx = 0;

    s.max_high = high_freq[0];
    for(int k = 0; k < 4; k++)
    {
        if(high_freq[k] > s.max_high)
        {
            s.max_high = high_freq[k];
            s.high_idx = k;
        }
    }

    // check for multple high frequency
    for(int k = 0; k <4; k++)
    {
        if(low_freq[k] == s.max_low)
        {
            s.mult_low = s.mult_low+1;
        }
    }

    for(int l = 0; l < 4; l++)
    {
        if(high_freq[l] == s.max_high)
        {
            s.mult_high = s.mult_high+1;
        }
    }


    return s;


}// end frequency_group


int dout = 255;
int out_1 = 0;
int out_2 = 255;
int seen_quiet = 1;
int ok = 0;
int low_idx = 0;
int high_idx = 0;
int max_high = 0;
int max_low = 0;

int input_arg( int array[8])
{
    //int input_data[8];
    Struct result;

    //int low_idx=0, high_idx=0;
   // int max_low=0, max_high=0;

    int mult_high=0, mult_low=0;

 //int dout ;
 //static  int out_1;
//static  int out_2 ;

//int seen_quiet=1;
//int ok;

//ok = 0;
//printf("next out_1: %d\n", out_1);
out_2 = out_1;
//printf("next out_2: %d\n", out_2);
low_idx = 8;
high_idx= 8;
mult_high = 0;
mult_low = 0;



    result = frequency_group(array);
    low_idx = result.low_idx;
    max_low = result.max_low;
    high_idx = result.high_idx;
    max_high = result.max_high;
    mult_high = result.mult_high;
    mult_low = result.mult_low;



//printf("-------------------low_idx: %d and max_low : %04x \n", low_idx, max_low);
//printf("-------------------high_idx: %d and max_high : %04x \n", high_idx, max_high);
//printf("##############################################################################\n");

//printf("----------------------------mult_high = %d, mult_low = %d\n", mult_high, mult_low);


    if(mult_high > 1 || mult_low > 1)
    {
//printf("seen mult freq %d, %d \n",mult_high, mult_low);
        out_1 = 0;
        ok = 0;
        mult_low = 0;
        mult_high = 0;
        low_idx = 8;
        high_idx = 8;
    }

    else if(max_low == 0 && max_high == 0)
    {
      ok = 0;
//out_1 = 0;
      low_idx = 8;
      high_idx = 8;
      mult_low = 0;
      mult_high = 0;
    }

    else if(low_idx != 8 && high_idx != 8)
    {
        out_1 = 0;
        ok = 0;

		if(max_low >= max_high)
		{
			if(max_high >= (max_low/4))
			{
				ok = 1;
			}
			else
			{
				ok = 0;
			}
		}

		else if(max_high >= max_low)
        {
		if(max_low >= (max_high/4))
		{
		ok = 1;
		}
		else
        {
		ok = 0;
		}
		}

		mult_low = 0;
		mult_high = 0;


     }// low_idx != 8


    if(ok ==1)
    {
//printf("-----here------\n");
//printf("high: %d, low: %d \n", max_high, max_low);
//printf("-------------------low_idx: %d and max_low : %04x \n", low_idx, max_low);
//printf("-------------------high_idx: %d and max_high : %04x \n", high_idx, max_high);
//printf("----------------------------ok: %d \n", ok);

        if(low_idx == 0)
		{
		  if(high_idx == 0)
		    out_1 = 49;
		  else if(high_idx == 1)
		    out_1 = 50;
		  else if(high_idx == 2)
		    out_1 = 51;
		  else if(high_idx == 3)
		    out_1 = 97;
		}

		else if(low_idx == 1)
		{
			if(high_idx == 0)
			out_1 = 52;
			else if(high_idx == 1)
			out_1 = 53;
			else if(high_idx == 2)
			out_1 = 54;
			else if(high_idx == 3)
			out_1 = 98;
		}

		else if(low_idx == 2)
		{
			if(high_idx== 0)
			out_1 = 55;
			else if(high_idx == 1)
			out_1 = 56;
			else if(high_idx == 2)
			out_1 = 57;
			else if(high_idx == 3)
			out_1 = 99;
		}

		else if(low_idx == 3)
		{
			if(high_idx == 0)
			out_1 = 42;
			else if(high_idx == 1)
			out_1 = 48;
			else if(high_idx == 2)
			out_1 = 35;
			else if(high_idx ==3)
			out_1 = 100;
		}

		else out_1 = 0;



    }// end ok = 1


	else
    {
        out_1 = 0;
   }


	if(out_1 == out_2)
	{
//printf("-----------out_1 %d \n", out_1);
//printf("-----------out_2 %d \n", out_2);
		if(out_2 == 0)
    	{
			seen_quiet = 1;
			//out_2 = out_1;
		}
		else
		{
			if(seen_quiet)
			{
				seen_quiet = 0;
				dout = out_2;
//printf("seen mult freq %d, %d \n",mult_high, mult_low);
//printf("-----------------ref out = %c \n", dout);
			}
			else out_2 = out_1;
		}
	}

	else {//printf("before out_2: %d \n", out_2);
        out_2 = out_1;
//printf("--------here ----out_2: %d out_1: %d \n", out_2, out_1);
    }


   for(int m = 0; m < 8; m++)
   {
    array[m] = 0;
    }
   
return dout;

}// end input_arg


/*
printf("---------------receive begin--------------\n");
printf("----------array_data = %04x \n", array[0]);
printf("----------array_data = %04x \n", array[1]);
printf("----------array_data = %04x \n", array[2]);
printf("----------array_data = %04x \n", array[3]);
printf("----------array_data = %04x \n", array[4]);
printf("----------array_data = %04x \n", array[5]);
printf("----------array_data = %04x \n", array[6]);
printf("----------array_data = %04x \n", array[7]);
printf("---------------receive end--------------\n");
*/












