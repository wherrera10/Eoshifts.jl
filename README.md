# Eoshifts.jl
Julia functions to emulate Fortran's eoshift

## eoshift(arr::AbstractArray, shift; dim = 1, boundary = :default)

Fortran's EOSHIFT for Julia arrays. Emulates Fortran, so shift directions are opposite
to Julia's built-in circshift. Fills with zeros by default (' ' for Char arrays), but
can take an optional `boundary` fill value. Works for N-dimensional arrays along the
specified dimension (default is 1, to shift rows, or specify with `dim`). `shift` is
either a scalar for the shift amount or an array with dimensions matching `arr` along
`dim`, so a 2 X 4 X 5 array with `dim` = 2 would have a shift array of size 2 X 5.
