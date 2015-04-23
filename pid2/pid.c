/*
 ============================================================================
 Name        : pid.c
 Author      : Group 16
 Version     :
 Copyright   : MIT
 Description : PID controller
 ============================================================================
 */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <pthread.h>
#include <stdbool.h>
#include <time.h>

static const double Kp = 4.;
static const double Ki = .5;
static const double Kd = 2.;
static const double Tf = 4.;
static const double K = 2.;
static const double T = 3.;
static const double h_plant = .1;
static const double h_controller = 1;

static pthread_mutex_t mx;


static double y = 0.0;
static double u = 0.0;
static double r = 0.0;

static bool is_running = 1;

double pid(double e) {
	static double eold_1 = 0.0;
	static double eold_2 = 0.0;
	static double uold_1 = 0.0;
	static double uold_2 = 0.0;

	double alpha = (h_controller - 2*Tf)/(h_controller + 2*Tf);
	double beta = (2*Kd)/(h_controller + 2*Tf);
	double a0 = (Kp - h_controller*Ki/2 - beta/alpha);

	double u = -alpha*a0*eold_2 +
               (h_controller*Ki*alpha + a0*(alpha - 1) - beta*(1 + 1/alpha))*eold_1 +
               (a0 + h_controller*Ki + beta*(1 + 1/alpha))*e +
               alpha*uold_2 - (alpha-1)*uold_1;

	eold_2 = eold_1;
	eold_1 = e;

	uold_2 = uold_1;
	uold_1 = u;
//	printf("%f\n", u);

	return u;
}

double plant(double u) {
	static double y_old = 0.0;

	double y = exp(-h_plant/T)*y_old + K*(1-exp(-h_plant/T))*u;

	y_old = y;
	return y;
}

void *process()
{
	FILE *fp_out = fopen("output.txt", "w");

	if (fp_out == NULL) {
		fprintf(stderr, "Can not write to file\n");
		exit(1);
	}

	struct timespec ts;
	ts.tv_sec = 1;
	ts.tv_nsec = 0;
	
	while (is_running)
	{
		pthread_mutex_lock(&mx);
			y = plant(u);
			fprintf(fp_out, "%f\n", y);
		pthread_mutex_unlock(&mx);
		nanosleep(&ts, NULL);
	}

	fclose(fp_out);
	pthread_exit(NULL);
}

void *controller()
{
	FILE *fp_in = fopen("setpointvalues.txt", "r");

	if (fp_in == NULL) {
		fprintf(stderr, "Can not open file\n");
		exit(1);
	}

	struct timespec ts;
	ts.tv_sec = 0;
	ts.tv_nsec = 100000000;

	while (fscanf(fp_in, "%lf", &r) != EOF) {
		pthread_mutex_lock(&mx);
			u = pid(r - y);
		pthread_mutex_unlock(&mx);
		nanosleep(&ts, NULL);
	}

	is_running = false;
	fclose(fp_in);
	pthread_exit(NULL);
}


int main(void) {
	pthread_mutex_init(&mx, NULL);

	pthread_t process_thread;
	pthread_t controller_thread;

	pthread_create(&process_thread, NULL, &process, NULL);
	pthread_create(&controller_thread, NULL, &controller, NULL);
	
	pthread_join(process_thread, NULL);
	pthread_join(controller_thread, NULL);
	pthread_mutex_destroy(&mx);

	return EXIT_SUCCESS;
}
