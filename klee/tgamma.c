// https://github.com/bminor/musl/blob/047a16398b29d2702a41a0d6d15370d54b9d723c/src/math/tgamma.c#L108
/*
"A Precision Approximation of the Gamma Function" - Cornelius Lanczos (1964)
"Lanczos Implementation of the Gamma Function" - Paul Godfrey (2001)
"An Analysis of the Lanczos Gamma Approximation" - Glendon Ralph Pugh (2004)

approximation method:

                        (x - 0.5)         S(x)
Gamma(x) = (x + g - 0.5)         *  ----------------
                                    exp(x + g - 0.5)

with
                 a1      a2      a3            aN
S(x) ~= [ a0 + ----- + ----- + ----- + ... + ----- ]
               x + 1   x + 2   x + 3         x + N

with a0, a1, a2, a3,.. aN constants which depend on g.

for x < 0 the following reflection formula is used:

Gamma(x)*Gamma(-x) = -pi/(x sin(pi x))

most ideas and constants are from boost and python
*/
#include "libm.h"

static const double pi = 3.141592653589793238462643383279502884;


// --------
// musl\src\math\__sin.c
static const double
S1  = -1.66666666666666324348e-01, /* 0xBFC55555, 0x55555549 */
S2  =  8.33333333332248946124e-03, /* 0x3F811111, 0x1110F8A6 */
S3  = -1.98412698298579493134e-04, /* 0xBF2A01A0, 0x19C161D5 */
S4  =  2.75573137070700676789e-06, /* 0x3EC71DE3, 0x57B1FE7D */
S5  = -2.50507602534068634195e-08, /* 0xBE5AE5E6, 0x8A2B9CEB */
S6  =  1.58969099521155010221e-10; /* 0x3DE5D93A, 0x5ACFD57C */

double musl__sin(double x, double y, int iy)
{
	double_t z,r,v,w;

	z = x*x;
	w = z*z;
	r = S2 + z*(S3 + z*S4) + z*w*(S5 + z*S6);
	v = z*x;
	if (iy == 0)
		return x + v*(S1 + z*r);
	else
		return x - ((z*(0.5*y - v*r) - y) - v*S1);
}

// musl\src\math\__cos.c
static const double
C1  =  4.16666666666666019037e-02, /* 0x3FA55555, 0x5555554C */
C2  = -1.38888888888741095749e-03, /* 0xBF56C16C, 0x16C15177 */
C3  =  2.48015872894767294178e-05, /* 0x3EFA01A0, 0x19CB1590 */
C4  = -2.75573143513906633035e-07, /* 0xBE927E4F, 0x809C52AD */
C5  =  2.08757232129817482790e-09, /* 0x3E21EE9E, 0xBDB4B1C4 */
C6  = -1.13596475577881948265e-11; /* 0xBDA8FAE9, 0xBE8838D4 */

double musl__cos(double x, double y)
{
	double_t hz,z,r,w;

	z  = x*x;
	w  = z*z;
	r  = z*(C1+z*(C2+z*C3)) + w*w*(C4+z*(C5+z*C6));
	hz = 0.5*z;
	w  = 1.0-hz;
	return w + (((1.0-w)-hz) + (z*r-x*y));
}

/* sin(pi x) with x > 0x1p-100, if sin(pi*x)==0 the sign is arbitrary */
static double sinpi(double x)
{
	int n;

	/* argument reduction: x = |x| mod 2 */
	/* spurious inexact when x is odd int */
	x = x * 0.5;
	x = 2 * (x - floor(x));

	/* reduce x into [-.25,.25] */
	n = 4 * x;
	n = (n+1)/2;
	x -= n * 0.5;

	x *= pi;
	switch (n) {
	default: /* case 4 */
	case 0:
		return musl__sin(x, 0, 0);
	case 1:
		return musl__cos(x, 0);
	case 2:
		return musl__sin(-x, 0, 0);
	case 3:
		return -musl__cos(x, 0);
	}
}

#define N 12
//static const double g = 6.024680040776729583740234375;
static const double gmhalf = 5.524680040776729583740234375;
static const double Snum[N+1] = {
	23531376880.410759688572007674451636754734846804940,
	42919803642.649098768957899047001988850926355848959,
	35711959237.355668049440185451547166705960488635843,
	17921034426.037209699919755754458931112671403265390,
	6039542586.3520280050642916443072979210699388420708,
	1439720407.3117216736632230727949123939715485786772,
	248874557.86205415651146038641322942321632125127801,
	31426415.585400194380614231628318205362874684987640,
	2876370.6289353724412254090516208496135991145378768,
	186056.26539522349504029498971604569928220784236328,
	8071.6720023658162106380029022722506138218516325024,
	210.82427775157934587250973392071336271166969580291,
	2.5066282746310002701649081771338373386264310793408,
};
static const double Sden[N+1] = {
	0, 39916800, 120543840, 150917976, 105258076, 45995730, 13339535,
	2637558, 357423, 32670, 1925, 66, 1,
};
/* n! for small integer n */
static const double fact[] = {
	1, 1, 2, 6, 24, 120, 720, 5040.0, 40320.0, 362880.0, 3628800.0, 39916800.0,
	479001600.0, 6227020800.0, 87178291200.0, 1307674368000.0, 20922789888000.0,
	355687428096000.0, 6402373705728000.0, 121645100408832000.0,
	2432902008176640000.0, 51090942171709440000.0, 1124000727777607680000.0,
};

/* S(x) rational function for positive x */
static double S(double x)
{
	double_t num = 0, den = 0;
	int i;

	/* to avoid overflow handle large x differently */
	if (x < 8)
		for (i = N; i >= 0; i--) {
			num = num * x + Snum[i];
			den = den * x + Sden[i];
		}
	else
		for (i = 0; i <= N; i++) {
			num = num / x + Snum[i];
			den = den / x + Sden[i];
		}
	return num/den;
}

double tgamma(double x)
{
	union {double f; uint64_t i;} u = {x};
	double absx, y;
	double_t dy, z, r;
	uint32_t ix = u.i>>32 & 0x7fffffff;
	int sign = u.i>>63;

	/* special cases */
	if (ix >= 0x7ff00000)
		/* tgamma(nan)=nan, tgamma(inf)=inf, tgamma(-inf)=nan with invalid */
		return x + INFINITY;
	if (ix < (0x3ff-54)<<20)
		/* |x| < 2^-54: tgamma(x) ~ 1/x, +-0 raises div-by-zero */
		return 1/x;

	/* integer arguments */
	/* raise inexact when non-integer */
	if (x == floor(x)) {
		if (sign)
			return 0/0.0;
		if (x <= sizeof fact/sizeof *fact)
			return fact[(int)x - 1];
	}

	/* x >= 172: tgamma(x)=inf with overflow */
	/* x =< -184: tgamma(x)=+-0 with underflow */
	if (ix >= 0x40670000) { /* |x| >= 184 */
		if (sign) {
			FORCE_EVAL((float)(0x1p-126/x));
			if (floor(x) * 0.5 == floor(x * 0.5))
				return 0;
			return -0.0;
		}
		x *= 0x1p1023;
		return x;
	}

	absx = sign ? -x : x;

	/* handle the error of x + g - 0.5 */
	y = absx + gmhalf;
	if (absx > gmhalf) {
		dy = y - absx;
		dy -= gmhalf;
	} else {
		dy = y - gmhalf;
		dy -= absx;
	}

	z = absx - 0.5;
	r = S(absx) * exp(-y);
	if (x < 0) {
		/* reflection formula for negative x */
		/* sinpi(absx) is not 0, integers are already handled */
		r = -pi / (sinpi(absx) * absx * r);
		dy = -dy;
		z = -z;
	}
	r += dy * (gmhalf+0.5) * r / y;
	z = pow(y, 0.5*z);
	y = r * z * z;
	return y;
}


/*
tiny-regex KLEE test driver
kindly contributed by @DavidKorczynski - see https://github.com/kokke/tiny-regex-c/issues/44
*/
#include "klee/klee.h"
int main(int argc, char* argv[])
{
  /* test input - ten chars used as a regex-pattern input */
  double x;

  /* make input symbolic, to search all paths through the code */
  /* i.e. the input is checked for all possible ten-char combinations */
  klee_make_symbolic(&x, sizeof(x), "x"); 

  /* assume proper NULL termination */
//   int test = (0.0<=x) & (x<=2.0);
//   klee_assume(test);

  /* verify abscence of run-time errors - go! */
  double y = tgamma(x);
//   int y_assert = (0<=y) & (y<=1);
//   klee_assert(y_assert);

  return 0;
}