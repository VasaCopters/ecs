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

static const double Kp = 2.;
static const double Ki = 0.5;
static const double Kd = 1.;
static const double Tf = 4.;
static const double K = 1.;
static const double T = 3.;
static const double h = .1;

double pid(double e) {
	static double eold_1 = 0.0;
	static double eold_2 = 0.0;
	static double uold_1 = 0.0;
	static double uold_2 = 0.0;

	double alpha = (h - 2*Tf)/(h + 2*Tf);
	double beta = (2*Kd)/(h + 2*Tf);
	double a0 = (Kp - h*Ki/2 - beta/alpha);

	double u = -alpha*a0*eold_2 +
               (h*Ki*alpha + a0*(alpha - 1) - beta*(1 + 1/alpha))*eold_1 +
               (a0 + h*Ki + beta*(1 + 1/alpha))*e +
               alpha*uold_2 - (alpha-1)*uold_1;

	eold_2 = eold_1;
	eold_1 = e;

	uold_2 = uold_1;
	uold_1 = u;

	return u;
}

double plant(double u) {
	static double y_old = 0.0;

	double y = exp(-h/T)*y_old + K*(1-exp(-h/T))*u;

	y_old = y;
	return y;
}

int main(void) {
	FILE *fp_in = fopen("setpointvalues.txt", "r");
	FILE *fp_out = fopen("output.txt", "w");

	if (fp_in == NULL) {
		fprintf(stderr, "Can not open file\n");
		exit(1);
	}
	if (fp_out == NULL) {
		fprintf(stderr, "Can not write to file\n");
		exit(1);
	}

	double y = 0.0;
	double u = 0.0;
	double r = 0.0;

	while (fscanf(fp_in, "%lf", &r) != EOF) {
		y = plant(u);
		u = pid(r - y);
		fprintf(fp_out, "%f\n", u);
	}

	fclose(fp_in);
	fclose(fp_out);

	return EXIT_SUCCESS;
}
