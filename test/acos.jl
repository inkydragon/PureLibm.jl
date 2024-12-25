# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "cr_acos(::$T)" begin
        # IEC 60559
        @test PureLibm.cr_acos(T(1)) == T(0)
        @test isnan(PureLibm.cr_acos(T(2)))
        @test isnan(PureLibm.cr_acos(T(-2)))
        @test isnan(PureLibm.cr_acos(T(Inf)))
        @test isnan(PureLibm.cr_acos(T(-Inf)))
        @test isnan(PureLibm.cr_acos(T(NaN)))

        # sanity check
        @test PureLibm.cr_acos(T(-1)) ≈ pi
        @test PureLibm.cr_acos(T(0)) * 2 ≈ pi
        @test PureLibm.cr_acos(T(0.5)) * 3 ≈ pi
    end
end


if "cr_acos.fast" in CheckExhaustive
# 2* 0.0:1.0    2130706434 cases    1m14.0s
@testset "acosf-exhaustive.fast" begin
    xlo = reinterpret(UInt32, Float32(0.0))
    xhi = reinterpret(UInt32, Float32(1.0))
    for xu in xlo:xhi, sign in [1, -1]
        x = reinterpret(Float32, xu)
        x = copysign(x, sign)
        y = PureLibm.cr_acos(x)
        z = acos(x)

        if isnan(z) && isnan(y)
            continue
        elseif isinf(z) && isinf(y)
            continue
        elseif z ≈ y
            continue
        else
            @printf("[xu = 0x%x (%e)]:  y=%e; z=%e\n", xu, x, y, z)
        end
    end
    println("test $(length(xlo:xhi)*2) cases")
end
end # CheckExhaustive

if "cr_acos" in CheckExhaustive
# 2130706434 cases  181m42.7s
@testset "cr_acos-exhaustive" begin
    xlo = reinterpret(UInt32, Float32(0.0))
    xhi = reinterpret(UInt32, Float32(1.0))
    for xu in xlo:xhi, sign in [1, -1]
        x = reinterpret(Float32, xu)
        x = copysign(x, sign)
        y = PureLibm.cr_acos(x)
        z = Float32(acos(BigFloat(x)))

        if y === z
            continue
        else
            @printf("[xu = 0x%x (%e)]:  y=%e; z=%e\n", xu, x, y, z)
        end
    end
    println("test $(length(xlo:xhi)*2) cases")
end

end # CheckExhaustive
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_acos.fast,cr_acos"
