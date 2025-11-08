module Eoshifts

export eoshift

"""
    eoshift(arr::T, shift::Int; dim = 1, boundary = :default)

    Fortran's EOSHIFT for Julia arrays. Emulates Fortran, so shift directions are
    opposite to Julia's built-in circshift. Fills with zeros by default
    (' ' for Char arrays), but can take an optional boundary fill value. Works for
    N-dimensional arrays along the specified dimension (default is 1, shift rows).
"""
function eoshift(arr::AbstractArray, shift::Int; dim = 1, boundary = :default)
    sz = size(arr)
    shifts = zeros(Int, length(sz))
    shifts[dim] = -shift  # Reverse direction for Fortran compatibility
    if boundary == :default
        boundary = eltype(arr) <: AbstractChar ? ' ' : 0
    end
    result = fill(eltype(arr)(boundary), sz...)  # Initialize result with fill value
    @inbounds for I in CartesianIndices(sz)
        new_I = Tuple(I)
        new_I_dim = new_I[dim] + shifts[dim]
        if 1 <= new_I_dim <= sz[dim]
            new_I = Base.setindex(new_I, new_I_dim, dim)
            result[new_I...] = arr[I]
        end
    end
    return result
end

"""
    eoshift(arr::AbstractArray, shift::AbstractArray; dim = 1, boundary = :default)

    Fortran's EOSHIFT for Julia arrays. Emulates Fortran, so shift directions are
    opposite to Julia's built-in circshift. Fills with zeros by default
    (' ' for Char arrays), but can take an optional `boundary` fill value.  Works
    for N-dimensional arrays along the specified dimension (default is 1, to shift rows).
    `shift` is an array with dimensions matching `arr` along `dim`, so a 2 X 4 X 5 array with
    `dim` = 2 would have a shift array of size 2 X 5.
"""
function eoshift(arr::AbstractArray, shift::AbstractArray; dim = 1, boundary = :default)
    sz = size(arr)
    @assert size(shift) == Tuple(sz[i] for i in eachindex(sz) if i != dim) "Shift array size must be $sz without dimension $dim"
    if boundary == :default
        boundary = eltype(arr) <: AbstractChar ? ' ' : 0
    end
    shifts = stack([shift for _ in 1:sz[dim]], dims=dim)
    result = fill(eltype(arr)(boundary), sz...)  # Initialize result with boundary value
    @inbounds for I in CartesianIndices(sz)
        new_I = Tuple(I)
        new_I_dim = new_I[dim] - shifts[I] # subtract for Fortran direction emulation
        if 1 <= new_I_dim <= sz[dim]
            new_I = Base.setindex(new_I, new_I_dim, dim)
            result[new_I...] = arr[I]
        end
    end
    return result
end

end # module Eoshifts
