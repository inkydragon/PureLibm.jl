# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "tanh(::$T)" begin
        # IEC 60559, F.10.2.6
        #   tanh(±0) returns ±0.
        @test PureLibm.tanh(T(+0.0)) ≈ +0.0
        @test PureLibm.tanh(T(-0.0)) ≈ -0.0
        #   tanh(±∞) returns ±1.
        @test PureLibm.tanh(T(+Inf)) === T(+1.0)
        @test PureLibm.tanh(T(-Inf)) === T(-1.0)

        # test NaN
        @test isnan(PureLibm.tanh(T(NaN)))
        @test isnan(PureLibm.tanh(T(-NaN)))
    end

    # random test
    test_x = T[
        # tanhf32(3pi) == 1
        # tanhf64(7pi) == 1
        (n*pi for n in 1:7)...,
        # [0.0, 7*pi]
        rand(0.0:eps():7pi, 10)...,
    ]
    # TODO: test -(test_x)
    @testset "tanh($x)" for x in test_x
        # Test against system libm
        @test PureLibm.tanh(x) ≈ tanh(x)
        # Test against MPFR
        @test PureLibm.tanh(x) === T(tanh(BigFloat(x)))
    end
end

if "tanhf.fast" in CheckExhaustive
    # 2* 0.0:1.0    2130706434 cases    3m43.3s
    @testset "tanhf-exhaustive.fast" begin
        xlo = reinterpret(UInt32, Float32(0.0))
        xhi = reinterpret(UInt32, Float32(1.0))
        for xu in xlo:xhi, sign in [1, -1]
            x = reinterpret(Float32, xu)
            x = copysign(x, sign)
            y = PureLibm.tanh(x)
            z = tanh(x)
    
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
