# Coppersmith-Method-for-cryptanalysis

Coppersmith method is used for finding small modular roots of polynomial with known coefficients and known modulus. Mathematically, given a polynomial 
$f(x) \in \mathbb{Z}[x]$ and an integer $r$ such that $f(x) \equiv 0$ mod $N$ as long as $r< N ^{1/d}$ where $d$ is the degree of $f$. 

The Coppersmith method is used for attacks on  cryptosystems such as the RSA and can be extended (heauristically) to multivariate-multipolynomial case as well. [This pdf](https://www.cits.ruhr-uni-bochum.de/imperia/md/content/may/paper/intro_to_coppersmiths_method.pdf) gives nice introduction to the Coppersmith method 

Assuming that you are now familiar witht he Coppersmith method, let me describe how this code will be helpful. In the Coppersmith method, we construct an integer lattice $\mathcal{L}$ with basis vectors as the "shift polynomials". By viewing the coefficient vectors of shift polynomials as vectors in $\mathbb{Z}^n$ (where $n$ is the number of monomials in the shift polynomial) we can construct a matrix, called as the basis matrix for the lattice $\mathcal{L}$. Generally, we want to select the shift polynomials in such a way that the corresponding matrix is a triangular matrix. This makes the determinant calculation easier, enabling us to calculate the exact bound for which the Coppersmith method works. How do we achieve this for a given set of initial polynomials?

This is often a tedious task. The simple algorithm presented in the sage file is helpful.

## Using the ALgorithm
Suppose we want to find integers $r_1, ..., r_l$ bounded as $r_i \leq X_i$, given the polynomials $g_1,. . ., g_l \in \mathbb{Z}[ x_1,..., x_l ]$ such that they have $r=(r_1,... ,r_l)$ as common root modulo some known integer $N$. For $i=1,... , l$ we  have: $$ g_i (r_1, ... r_l) = 0 \hspace{4pt} mod \hspace{2pt} N $$
Following the Coppersmith method, We set the parameter $m=2$ and consider finitely many shift polynomials, say $f_1, . . . f_n$ with the root $r$ modulo $N^m$.  Giving these polynomials as the input to the above algorithm, we will get the maximal subset $\{f_{i_1}, f_{i_2}, . . ., f_{i_l}\}$ of  $\{f_1, f_2, . . ., f_m\}$ such that the corresponding matrix is triangular. Repeating the procedure for $m=3, 4,$, etc, we may see a pattern for the choice of shift polynomials that can be generalized for any given $m$. This, in turn, will enable us to calculate the asymptotic bound for $m \xrightarrow{} \infty $.

It must be noted that this algorithm does not guarantee the optimality of the choice of shift polynomials. After removing some polynomials from the algorithm output, we may get a better bound. The analysis of optimality depends on the initial polynomials of the particular problem at hand. 
