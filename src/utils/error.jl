
function domain_error_ignore()
    # errno = EDOM
    # feraiseexcept(FE_INVALID)
    @warn "DomainError"
end

function domain_error(val, msg="")
    domain_error_ignore()
    throw(DomainError(val, msg))
end

function pole_error(x)
    # errno = ERANGE
    # feraiseexcept(FE_DIVBYZERO)
    @warn "At Pole: $(x)"
end

function overflow_error()
    # errno = ERANGE
    # feraiseexcept(FE_OVERFLOW)
    @warn "Overflow"
end

function underflow_error()
    # errno = ERANGE
    # feraiseexcept(FE_UNDERFLOW)
    @warn "Underflow"
end
