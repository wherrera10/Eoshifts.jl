using Eoshifts: eoshift
using Test

@test eoshift([1, 2, 3, 4], 2) == [3, 4, 0, 0]
@test eoshift([1, 2, 3, 4], -2, boundary = 9) == [9, 9, 1, 2]
@test eoshift(['a', 'b', 'c'], 1) == ['b', 'c', ' ']
const a = reshape(1:9, 3, 3)
@test eoshift(a, 1, dim = 2) == [4 7 0; 5 8 0; 6 9 0]
@test eoshift(a, -1, dim = 1, boundary = 99) == [99 99 99; 1 4 7; 2 5 8]
@test eoshift(a, [1, 2, 1], dim = 2, boundary = -5) == [4 7 -5; 8 -5 -5; 6 9 -5]
@test eoshift(a, [1, 2, 1], dim = 1) == [2 6 8; 3 0 9; 0 0 0]
const b = reshape(1:24, (2, 3, 4))
@test eoshift(b, 1, dim = 3)[:, :, 1] == [7 9 11; 8 10 12]
@test eoshift(b, 1, dim = 2, boundary = -7)[:, 1, :] == [3 9 15 21; 4 10 16 22]
@test eoshift(b, -1, dim = 2, boundary = -7)[:, 3, :] == [3 9 15 21; 4 10 16 22]
@test eoshift(b, [1 1 1 1; 0 0 0 0; 1 1 1 1], dim = 1)[:, :, 1] == [2 3 6; 0 4 0]
@test eoshift(b, [1 1 1 1; 0 0 0 0], dim = 2)[:, 1, :] == [3 9 15 21; 2 8 14 20]
@test eoshift(b, [1 1 1; 0 0 0], dim = 3)[:, :, 1] == [7 9 11; 2 4 6]
