import numpy as np

R.<x,y,z> = PolynomialRing(QQ)

# initial polynomials
f = x*y + x + 1
g = y*z + y + 1


# generate shift polynomials
m = 3

shift_polynomials = []          # list of shift polynomials
poly_dict = []                  # list of expreessions of shift polynomials in string format

for extrapower in [1,x,y] :     # extra shifts in each variable
    for i in range(m+1):
        for j in range(m+1-i):
            poly = x^j*f^i
            shift_polynomials.append(poly)
            poly_dict.append('{:1s}^{} f^{}'.format(str(x), j, i)) # store the expression of shift polynomials
        for j in range(0,2) :
            poly = y^j*f^i
            shift_polynomials.append(poly)
            poly_dict.append('{:1s}^{} f^{}'.format(str(y), j, i)) # store the expression of shift polynomials


# set of monomials of all shift polynomials
Monomials = []
for poly in shift_polynomials:
    Monomials = union(Monomials, poly.monomials())
Monomials = sorted(Monomials)


def create_matrix(shift_polynomials) :
    # create tha matrix for shift polynomials
    # (ij)-th entry of the matrix is 1 if j-th mononmial is present in i-th polynomial and 0 otherwise

    matrix_for_shifts = [ [0]+[int(k) for k in range(len(Monomials))] ] # first row contains the list of monomials

    for i in range( len(shift_polynomials) ) :
        row = [int(i)] # first column is for indexing the polynomials 
        for j in range( len(Monomials) ) :
            if shift_polynomials[i].monomial_coefficient( Monomials[j] ) : 
                row.append(int(1))
            else :
                row.append(int(0))

        matrix_for_shifts.append(row)

    matrix_for_shifts = np.array(matrix_for_shifts)

    return matrix_for_shifts

def swap_rows(M, i, j) :
    r1 = M[i]; r2 = M[j]
    M1 = M.copy()
    M1[i] = r2; M1[j] = r1
    return M1 

def swap_columns(M, i, j) :
    c1 = M[:,i]; c2 = M[:,j]
    M1 = M.copy()
    M1[:,i] = c2; M1[:,j] = c1
    return M1 


def step(A) :
    # finds next polynomial that can be moved to the beginning of the matrix
    # this polynomial is such that it adds just 1 new monomial
    #B = [ np.sum(A[:,j]) for j in range(A.shape[1]) ]  # B[j] = total number of polynmials in which the j-th monomial appears
    C = [ np.sum(A[i,:]) for i in range(A.shape[0]) ]  # C[i] = total number of monomials in the i-th polynomial 
    
    # find polynomial k with Ck = 1
    for k in range( A.shape[0] ) :
        # k-th polynomial adds monomial l
        if C[k] == 1 : 
            for l in range( A.shape[1] ) :
                if A[k][l]  :
                    return k, l
    return -1, -1


def build_triangular_basis(A) : 
    # 1st row and 1st column of the input matrix are for index of polynomials and monomials respectively
    count = 0
    while True :
        # look for polynomials which have just one new monomial
        # and add them to the end of the current triangular matrix
        
        k, l = step( A[ count+1: A.shape[0], count+1: A.shape[1] ] )  
        if k == -1 :
            print('Maximal tiangular matrix constructed')
            break

        #print("swap rows ", count+k+1, count+1, "swap columns "  , count+l+1, count+1)
        A = swap_rows(A, count+k+1, count+1 )
        A = swap_columns(A, count+l+1, count+1)
        #print("after swapping ", A)
        #print("")

        count += 1
            
    return A[:count+1,:count+1]


matrix_for_shifts = create_matrix(shift_polynomials)

print(len(shift_polynomials), "shift polynomials generated")
print('Total number of monomials: ', len(Monomials))
print("Initial matrix dimensions: ", matrix_for_shifts.shape)
print('')

final_matrix = build_triangular_basis(matrix_for_shifts)

print('Dimensions:', final_matrix.shape[0]-1, 'x',final_matrix.shape[1]-1)
print('Monomial order: ', [Monomials[j] for j in final_matrix[0,1:]])
for i in range(1,final_matrix.shape[0]) :
    print( poly_dict[final_matrix[i,0]], final_matrix[i,1:] )

