############# time-independent Hamiltonian (noiseless) ################
function PSO_QFIM(pso::TimeIndepend_noiseless{T}, max_episode, particle_num, ini_particle, c0, c1, c2, v0, sd, save_file) where {T<: Complex}
    println("state optimization")
    Random.seed!(sd)
    dim = length(pso.psi)
    particles = repeat(pso, particle_num)
    velocity = v0.*rand(ComplexF64, dim, particle_num)
    pbest = zeros(ComplexF64, dim, particle_num)
    gbest = zeros(ComplexF64, dim)
    velocity_best = zeros(ComplexF64, dim)
    p_fit = zeros(particle_num)

    if typeof(max_episode) == Int
        max_episode = [max_episode, max_episode]
    end

    # initialize
    if length(ini_particle) > particle_num
        ini_particle = [ini_particle[i] for i in 1:particle_num]
    end
    for pj in 1:length(ini_particle)
        particles[pj].psi = [ini_particle[pj][i] for i in 1:dim]
    end
    for pj in (length(ini_particle)+1):particle_num
        r_ini = 2*rand(dim)-ones(dim)
        r = r_ini/norm(r_ini)
        phi = 2*pi*rand(dim)
        particles[pj].psi = [r[i]*exp(1.0im*phi[i]) for i in 1:dim]
    end

    F = QFIM_TimeIndepend(pso.freeHamiltonian, pso.Hamiltonian_derivative, pso.psi, pso.tspan, pso.accuracy)
    qfi_ini = real(tr(pso.W*pinv(F)))

    if length(pso.Hamiltonian_derivative) == 1
        println("single parameter scenario")
        println("search algorithm: Particle Swarm Optimization (PSO)")
        println("initial QFI is $(1.0/qfi_ini)")      
        fit = 0.0
        f_list = [1.0/qfi_ini]
        if save_file==true
            for ei in 1:(max_episode[1]-1)
                #### train ####
                p_fit, fit, pbest, gbest, velocity_best, velocity = train_QFIM_noiseless(particles, p_fit, fit, max_episode, c0, c1, c2, particle_num, 
                                                                                        dim, pbest, gbest, velocity_best, velocity)
                if ei%max_episode[2] == 0
                    pso.psi = [gbest[i] for i in 1:dim]
                    particles = repeat(pso, particle_num)
                end
                append!(f_list, fit)
                SaveFile_state(f_list, gbest)
                print("current QFI is $fit ($ei episodes) \r")
                
            end
            p_fit, fit, pbest, gbest, velocity_best, velocity = train_QFIM_noiseless(particles, p_fit, fit, max_episode, c0, c1, c2, particle_num, 
                                                                                        dim, pbest, gbest, velocity_best, velocity)
            append!(f_list, fit)
            SaveFile_state(f_list, gbest)
            print("\e[2K")    
            println("Iteration over, data saved.")
            println("Final QFI is $fit")
        else
            for ei in 1:(max_episode[1]-1)
                #### train ####
                p_fit, fit, pbest, gbest, velocity_best, velocity = train_QFIM_noiseless(particles, p_fit, fit, max_episode, c0, c1, c2, particle_num, 
                                                                                        dim, pbest, gbest, velocity_best, velocity)
                if ei%max_episode[2] == 0
                    pso.psi = [gbest[i] for i in 1:dim]
                    particles = repeat(pso, particle_num)
                end
                append!(f_list, fit)
                print("current QFI is $fit ($ei episodes) \r")
            end
            p_fit, fit, pbest, gbest, velocity_best, velocity = train_QFIM_noiseless(particles, p_fit, fit, max_episode, c0, c1, c2, particle_num, 
                                                                                        dim, pbest, gbest, velocity_best, velocity)
            append!(f_list, fit)
            SaveFile_state(f_list, gbest)
            print("\e[2K") 
            println("Iteration over, data saved.") 
            println("Final QFI is $fit")
        end
    else
        println("multiparameter scenario")
        println("search algorithm: Particle Swarm Optimization (PSO)")
        println("initial value of Tr(WF^{-1}) is $(qfi_ini)")       
        fit = 0.0
        f_list = [qfi_ini]
        if save_file==true
            for ei in 1:(max_episode[1]-1)
                #### train ####
                p_fit, fit, pbest, gbest, velocity_best, velocity = train_QFIM_noiseless(particles, p_fit, fit, max_episode, c0, c1, c2, particle_num, 
                                                                                    dim, pbest, gbest, velocity_best, velocity)
                if ei%max_episode[2] == 0
                    pso.psi = [gbest[i] for i in 1:dim]
                    particles = repeat(pso, particle_num)
                end
                append!(f_list, (1.0/fit))
                SaveFile_state(f_list, gbest)
                print("current value of Tr(WF^{-1}) is $(1.0/fit) ($ei episodes) \r")
            end
            p_fit, fit, pbest, gbest, velocity_best, velocity = train_QFIM_noiseless(particles, p_fit, fit, max_episode, c0, c1, c2, particle_num, 
                                                                                    dim, pbest, gbest, velocity_best, velocity)
            append!(f_list, (1.0/fit))
            SaveFile_state(f_list, gbest)
            print("\e[2K")
            println("Iteration over, data saved.")
            println("Final value of Tr(WF^{-1}) is $(1.0/fit)")
        else
            for ei in 1:(max_episode[1]-1)
                #### train ####
                p_fit, fit, pbest, gbest, velocity_best, velocity = train_QFIM_noiseless(particles, p_fit, fit, max_episode, c0, c1, c2, particle_num, 
                                                                                    dim, pbest, gbest, velocity_best, velocity)
                if ei%max_episode[2] == 0
                    pso.psi = [gbest[i] for i in 1:dim]
                    particles = repeat(pso, particle_num)
                end
                append!(f_list, (1.0/fit))
                print("current value of Tr(WF^{-1}) is $(1.0/fit) ($ei episodes) \r")
            end
            p_fit, fit, pbest, gbest, velocity_best, velocity = train_QFIM_noiseless(particles, p_fit, fit, max_episode, c0, c1, c2, particle_num, 
                                                                                    dim, pbest, gbest, velocity_best, velocity)
            append!(f_list, (1.0/fit))
            SaveFile_state(f_list, gbest)
            print("\e[2K") 
            println("Iteration over, data saved.") 
            println("Final value of Tr(WF^{-1}) is $(1.0/fit)")
        end
    end
end

function PSO_CFIM(M, pso::TimeIndepend_noiseless{T}, max_episode, particle_num, ini_particle, c0, c1, c2, v0, sd, save_file) where {T<: Complex}
    println("state optimization")
    Random.seed!(sd)
    dim = length(pso.psi)
    particles = repeat(pso, particle_num)
    velocity = v0.*rand(ComplexF64, dim, particle_num)
    pbest = zeros(ComplexF64, dim, particle_num)
    gbest = zeros(ComplexF64, dim)
    velocity_best = zeros(ComplexF64, dim)
    p_fit = zeros(particle_num)

    if typeof(max_episode) == Int
        max_episode = [max_episode, max_episode]
    end

    # initialize
    if length(ini_particle) > particle_num
        ini_particle = [ini_particle[i] for i in 1:particle_num]
    end
    for pj in 1:length(ini_particle)
        particles[pj].psi = [ini_particle[pj][i] for i in 1:dim]
    end
    for pj in (length(ini_particle)+1):particle_num
        r_ini = 2*rand(dim)-ones(dim)
        r = r_ini/norm(r_ini)
        phi = 2*pi*rand(dim)
        particles[pj].psi = [r[i]*exp(1.0im*phi[i]) for i in 1:dim]
    end

    F = CFIM_TimeIndepend(M, pso.freeHamiltonian, pso.Hamiltonian_derivative, pso.psi, pso.tspan, pso.accuracy)
    f_ini = real(tr(pso.W*pinv(F)))

    if length(pso.Hamiltonian_derivative) == 1
        println("single parameter scenario")
        println("search algorithm: Particle Swarm Optimization (PSO)")
        println("initial CFI is $(1.0/f_ini)") 
        fit = 0.0
        f_list = [1.0/f_ini]
        if save_file==true
            for ei in 1:(max_episode[1]-1)
                #### train ####
                p_fit, fit, pbest, gbest, velocity_best, velocity = train_CFIM_noiseless(M, particles, p_fit, fit, max_episode, c0, c1, c2, particle_num, 
                                                                                        dim, pbest, gbest, velocity_best, velocity)
                if ei%max_episode[2] == 0
                    pso.psi = [gbest[i] for i in 1:dim]
                    particles = repeat(pso, particle_num)
                end
                append!(f_list, fit)
                SaveFile_state(f_list, gbest)
                print("current CFI is $fit ($ei episodes) \r")
                
            end
            p_fit, fit, pbest, gbest, velocity_best, velocity = train_CFIM_noiseless(M, particles, p_fit, fit, max_episode, c0, c1, c2, particle_num, 
                                                                                        dim, pbest, gbest, velocity_best, velocity)
            append!(f_list, fit)
            SaveFile_state(f_list, gbest)
            print("\e[2K")    
            println("Iteration over, data saved.")
            println("Final CFI is $fit")
        else
            for ei in 1:(max_episode[1]-1)
                #### train ####
                p_fit, fit, pbest, gbest, velocity_best, velocity = train_CFIM_noiseless(M, particles, p_fit, fit, max_episode, c0, c1, c2, particle_num, 
                                                                                        dim, pbest, gbest, velocity_best, velocity)
                if ei%max_episode[2] == 0
                    pso.psi = [gbest[i] for i in 1:dim]
                    particles = repeat(pso, particle_num)
                end
                append!(f_list, fit)
                print("current CFI is $fit ($ei episodes) \r")
            end
            p_fit, fit, pbest, gbest, velocity_best, velocity = train_CFIM_noiseless(M, particles, p_fit, fit, max_episode, c0, c1, c2, particle_num, 
                                                                                        dim, pbest, gbest, velocity_best, velocity)
            append!(f_list, fit) 
            SaveFile_state(f_list, gbest)
            print("\e[2K") 
            println("Iteration over, data saved.") 
            println("Final CFI is $fit")
        end
    else
        println("multiparameter scenario")
        println("search algorithm: Particle Swarm Optimization (PSO)")
        println("initial value of Tr(WF^{-1}) is $(f_ini)")
        fit = 0.0
        f_list = [f_ini]
        if save_file==true
            for ei in 1:(max_episode[1]-1)
                #### train ####
                p_fit, fit, pbest, gbest, velocity_best, velocity = train_CFIM_noiseless(M, particles, p_fit, fit, max_episode, c0, c1, c2, particle_num, 
                                                                                    dim, pbest, gbest, velocity_best, velocity)
                if ei%max_episode[2] == 0
                    pso.psi = [gbest[i] for i in 1:dim]
                    particles = repeat(pso, particle_num)
                end
                append!(f_list, (1.0/fit))
                print("current value of Tr(WF^{-1}) is $(1.0/fit) ($ei episodes) \r")
                SaveFile_state(f_list, gbest)
            end
            p_fit, fit, pbest, gbest, velocity_best, velocity = train_CFIM_noiseless(M, particles, p_fit, fit, max_episode, c0, c1, c2, particle_num, 
                                                                                    dim, pbest, gbest, velocity_best, velocity)
            append!(f_list, (1.0/fit))
            print("\e[2K")
            println("Iteration over, data saved.")
            println("Final value of Tr(WF^{-1}) is $(1.0/fit)")
        else
            for ei in 1:(max_episode[1]-1)
                #### train ####
                p_fit, fit, pbest, gbest, velocity_best, velocity = train_CFIM_noiseless(M, particles, p_fit, fit, max_episode, c0, c1, c2, particle_num, 
                                                                                    dim, pbest, gbest, velocity_best, velocity)
                if ei%max_episode[2] == 0
                    pso.psi = [gbest[i] for i in 1:dim]
                    particles = repeat(pso, particle_num)
                end
                append!(f_list, (1.0/fit))
                print("current value of Tr(WF^{-1}) is $(1.0/fit) ($ei episodes) \r")
            end
            p_fit, fit, pbest, gbest, velocity_best, velocity = train_CFIM_noiseless(M, particles, p_fit, fit, max_episode, c0, c1, c2, particle_num, 
                                                                                    dim, pbest, gbest, velocity_best, velocity)
            append!(f_list, (1.0/fit))
            SaveFile_state(f_list, gbest)
            print("\e[2K") 
            println("Iteration over, data saved.") 
            println("Final value of Tr(WF^{-1}) is $(1.0/fit)")
        end
    end
end

function train_QFIM_noiseless(particles, p_fit, fit, max_episode, c0, c1, c2, particle_num, dim, pbest, gbest, velocity_best, velocity)
    for pj in 1:particle_num
        F_tp = QFIM_TimeIndepend(particles[pj].freeHamiltonian, particles[pj].Hamiltonian_derivative, particles[pj].psi, 
                                 particles[pj].tspan, particles[pj].accuracy)
        f_now = 1.0/real(tr(particles[pj].W*pinv(F_tp)))
        if f_now > p_fit[pj]
            p_fit[pj] = f_now
            for di in 1:dim
                pbest[di,pj] = particles[pj].psi[di]
            end
        end
    end

    for pj in 1:particle_num
        if p_fit[pj] > fit
            fit = p_fit[pj]
            for dj in 1:dim
                gbest[dj] = particles[pj].psi[dj]
                velocity_best[dj] = velocity[dj, pj]
            end
        end
    end  

    for pk in 1:particle_num
        psi_pre = zeros(ComplexF64, dim)
        for dk in 1:dim
            psi_pre[dk] = particles[pk].psi[dk]
            velocity[dk, pk] = c0*velocity[dk, pk] + c1*rand()*(pbest[dk, pk] - particles[pk].psi[dk]) + c2*rand()*(gbest[dk] - particles[pk].psi[dk])
            particles[pk].psi[dk] = particles[pk].psi[dk] + velocity[dk, pk]
        end
        particles[pk].psi = particles[pk].psi/norm(particles[pk].psi)

        for dm in 1:dim
            velocity[dm, pk] = particles[pk].psi[dm] - psi_pre[dm]
        end
    end
    return p_fit, fit, pbest, gbest, velocity_best, velocity
end

function train_CFIM_noiseless(M, particles, p_fit, fit, max_episode, c0, c1, c2, particle_num, dim, pbest, gbest, velocity_best, velocity)
    for pj in 1:particle_num
        F_tp = CFIM_TimeIndepend(M, particles[pj].freeHamiltonian, particles[pj].Hamiltonian_derivative, particles[pj].psi, 
                                 particles[pj].tspan, particles[pj].accuracy)
        f_now = 1.0/real(tr(particles[pj].W*pinv(F_tp)))
        if f_now > p_fit[pj]
            p_fit[pj] = f_now
            for di in 1:dim
                pbest[di,pj] = particles[pj].psi[di]
            end
        end
    end

    for pj in 1:particle_num
        if p_fit[pj] > fit
            fit = p_fit[pj]
            for dj in 1:dim
                gbest[dj] = particles[pj].psi[dj]
                velocity_best[dj] = velocity[dj, pj]
            end
        end
    end  

    for pk in 1:particle_num
        psi_pre = zeros(ComplexF64, dim)
        for dk in 1:dim
            psi_pre[dk] = particles[pk].psi[dk]
            velocity[dk, pk] = c0*velocity[dk, pk] + c1*rand()*(pbest[dk, pk] - particles[pk].psi[dk]) + c2*rand()*(gbest[dk] - particles[pk].psi[dk])
            particles[pk].psi[dk] = particles[pk].psi[dk] + velocity[dk, pk]
        end
        particles[pk].psi = particles[pk].psi/norm(particles[pk].psi)

        for dm in 1:dim
            velocity[dm, pk] = particles[pk].psi[dm] - psi_pre[dm]
        end
    end
    return p_fit, fit, pbest, gbest, velocity_best, velocity
end

############# time-independent Hamiltonian (noise) ################
function PSO_QFIM(pso::TimeIndepend_noise{T}, max_episode, particle_num, ini_particle, c0, c1, c2, v0, sd, save_file) where {T<: Complex}
    println("state optimization")
    Random.seed!(sd)
    dim = length(pso.psi)
    particles = repeat(pso, particle_num)
    velocity = v0.*rand(ComplexF64, dim, particle_num)
    pbest = zeros(ComplexF64, dim, particle_num)
    gbest = zeros(ComplexF64, dim)
    velocity_best = zeros(ComplexF64, dim)
    p_fit = zeros(particle_num)

    if typeof(max_episode) == Int
        max_episode = [max_episode, max_episode]
    end

    # initialize
    if length(ini_particle) > particle_num
        ini_particle = [ini_particle[i] for i in 1:particle_num]
    end
    for pj in 1:length(ini_particle)
        particles[pj].psi = [ini_particle[pj][i] for i in 1:dim]
    end
    for pj in (length(ini_particle)+1):particle_num
        r_ini = 2*rand(dim)-ones(dim)
        r = r_ini/norm(r_ini)
        phi = 2*pi*rand(dim)
        particles[pj].psi = [r[i]*exp(1.0im*phi[i]) for i in 1:dim]
    end

    F = QFIM_TimeIndepend(pso.freeHamiltonian, pso.Hamiltonian_derivative, pso.psi*(pso.psi)', pso.decay_opt, pso.γ, pso.tspan, pso.accuracy)
    qfi_ini = real(tr(pso.W*pinv(F)))

    if length(pso.Hamiltonian_derivative) == 1
        println("single parameter scenario")
        println("search algorithm: Particle Swarm Optimization (PSO)")
        println("initial QFI is $(1.0/qfi_ini)")
        fit = 0.0
        f_list = [1.0/qfi_ini]
        if save_file==true
            for ei in 1:(max_episode[1]-1)
                #### train ####
                p_fit, fit, pbest, gbest, velocity_best, velocity = train_QFIM_noise(particles, p_fit, fit, max_episode, c0, c1, c2, particle_num, 
                                                                                        dim, pbest, gbest, velocity_best, velocity)
                if ei%max_episode[2] == 0
                    pso.psi = [gbest[i] for i in 1:dim]
                    particles = repeat(pso, particle_num)
                end
                append!(f_list, fit)
                SaveFile_state(f_list, gbest)
                print("current QFI is $fit ($ei episodes) \r")
                
            end
            p_fit, fit, pbest, gbest, velocity_best, velocity = train_QFIM_noise(particles, p_fit, fit, max_episode, c0, c1, c2, particle_num, 
                                                                                        dim, pbest, gbest, velocity_best, velocity)
            append!(f_list, fit)
            SaveFile_state(f_list, gbest)
            print("\e[2K")
            println("Iteration over, data saved.")
            println("Final QFI is $fit")
        else
            for ei in 1:(max_episode[1]-1)
                #### train ####
                p_fit, fit, pbest, gbest, velocity_best, velocity = train_QFIM_noise(particles, p_fit, fit, max_episode, c0, c1, c2, particle_num, 
                                                                                        dim, pbest, gbest, velocity_best, velocity)
                if ei%max_episode[2] == 0
                    pso.psi = [gbest[i] for i in 1:dim]
                    particles = repeat(pso, particle_num)
                end
                append!(f_list, fit)
                print("current QFI is $fit ($ei episodes) \r")
            end
            p_fit, fit, pbest, gbest, velocity_best, velocity = train_QFIM_noise(particles, p_fit, fit, max_episode, c0, c1, c2, particle_num, 
                                                                                        dim, pbest, gbest, velocity_best, velocity)
            append!(f_list, fit)
            SaveFile_state(f_list, gbest)
            print("\e[2K") 
            println("Iteration over, data saved.") 
            println("Final QFI is $fit")
        end
    else
        println("multiparameter scenario")
        println("search algorithm: Particle Swarm Optimization (PSO)")
        println("initial value of Tr(WF^{-1}) is $(qfi_ini)")
        fit = 0.0
        f_list = [qfi_ini]
        if save_file==true
            for ei in 1:(max_episode[1]-1)
                #### train ####
                p_fit, fit, pbest, gbest, velocity_best, velocity = train_QFIM_noise(particles, p_fit, fit, max_episode, c0, c1, c2, particle_num, 
                                                                                    dim, pbest, gbest, velocity_best, velocity)
                if ei%max_episode[2] == 0
                    pso.psi = [gbest[i] for i in 1:dim]
                    particles = repeat(pso, particle_num)
                end
                append!(f_list, (1.0/fit))
                SaveFile_state(f_list, gbest)
                print("current value of Tr(WF^{-1}) is $(1.0/fit) ($ei episodes) \r")
            end
            p_fit, fit, pbest, gbest, velocity_best, velocity = train_QFIM_noise(particles, p_fit, fit, max_episode, c0, c1, c2, particle_num, 
                                                                                    dim, pbest, gbest, velocity_best, velocity)
            append!(f_list, (1.0/fit))
            SaveFile_state(f_list, gbest)
            print("\e[2K")
            println("Iteration over, data saved.")
            println("Final value of Tr(WF^{-1}) is $(1.0/fit)")
        else
            for ei in 1:(max_episode[1]-1)
                #### train ####
                p_fit, fit, pbest, gbest, velocity_best, velocity = train_QFIM_noise(particles, p_fit, fit, max_episode, c0, c1, c2, particle_num, 
                                                                                    dim, pbest, gbest, velocity_best, velocity)
                if ei%max_episode[2] == 0
                    pso.psi = [gbest[i] for i in 1:dim]
                    particles = repeat(pso, particle_num)
                end
                append!(f_list, (1.0/fit))
                print("current value of Tr(WF^{-1}) is $(1.0/fit) ($ei episodes) \r")
            end
            p_fit, fit, pbest, gbest, velocity_best, velocity = train_QFIM_noise(particles, p_fit, fit, max_episode, c0, c1, c2, particle_num, 
                                                                                    dim, pbest, gbest, velocity_best, velocity)
            append!(f_list, (1.0/fit))
            SaveFile_state(f_list, gbest)
            print("\e[2K") 
            println("Iteration over, data saved.") 
            println("Final value of Tr(WF^{-1}) is $(1.0/fit)")
        end
    end
end

function PSO_CFIM(M, pso::TimeIndepend_noise{T}, max_episode, particle_num, ini_particle, c0, c1, c2, v0, sd, save_file) where {T<: Complex}
    println("state optimization")
    Random.seed!(sd)
    dim = length(pso.psi)
    particles = repeat(pso, particle_num)
    velocity = v0.*rand(ComplexF64, dim, particle_num)
    pbest = zeros(ComplexF64, dim, particle_num)
    gbest = zeros(ComplexF64, dim)
    velocity_best = zeros(ComplexF64, dim)
    p_fit = zeros(particle_num)

    if typeof(max_episode) == Int
        max_episode = [max_episode, max_episode]
    end
    
    # initialize
    if length(ini_particle) > particle_num
        ini_particle = [ini_particle[i] for i in 1:particle_num]
    end
    for pj in 1:length(ini_particle)
        particles[pj].psi = [ini_particle[pj][i] for i in 1:dim]
    end
    for pj in (length(ini_particle)+1):particle_num
        r_ini = 2*rand(dim)-ones(dim)
        r = r_ini/norm(r_ini)
        phi = 2*pi*rand(dim)
        particles[pj].psi = [r[i]*exp(1.0im*phi[i]) for i in 1:dim]
    end

    F = CFIM_TimeIndepend(M, pso.freeHamiltonian, pso.Hamiltonian_derivative, pso.psi*(pso.psi)', pso.decay_opt, pso.γ, pso.tspan, pso.accuracy)
    f_ini = real(tr(pso.W*pinv(F)))

    if length(pso.Hamiltonian_derivative) == 1
        println("single parameter scenario")
        println("search algorithm: Particle Swarm Optimization (PSO)")
        println("initial CFI is $(1.0/f_ini)")
        fit = 0.0
        f_list = [1.0/f_ini]
        if save_file==true
            for ei in 1:(max_episode[1]-1)
                #### train ####
                p_fit, fit, pbest, gbest, velocity_best, velocity = train_CFIM_noise(M, particles, p_fit, fit, max_episode, c0, c1, c2, particle_num, 
                                                                                        dim, pbest, gbest, velocity_best, velocity)
                if ei%max_episode[2] == 0
                    pso.psi = [gbest[i] for i in 1:dim]
                    particles = repeat(pso, particle_num)
                end
                append!(f_list, fit)
                SaveFile_state(f_list, gbest)
                print("current CFI is $fit ($ei episodes) \r")
                
            end
            p_fit, fit, pbest, gbest, velocity_best, velocity = train_CFIM_noise(M, particles, p_fit, fit, max_episode, c0, c1, c2, particle_num, 
                                                                                        dim, pbest, gbest, velocity_best, velocity)
            append!(f_list, fit)
            SaveFile_state(f_list, gbest)
            print("\e[2K")
            println("Iteration over, data saved.")
            println("Final CFI is $fit")
        else
            for ei in 1:(max_episode[1]-1)
                #### train ####
                p_fit, fit, pbest, gbest, velocity_best, velocity = train_CFIM_noise(M, particles, p_fit, fit, max_episode, c0, c1, c2, particle_num, 
                                                                                        dim, pbest, gbest, velocity_best, velocity)
                if ei%max_episode[2] == 0
                    pso.psi = [gbest[i] for i in 1:dim]
                    particles = repeat(pso, particle_num)
                end
                append!(f_list, fit)
                print("current CFI is $fit ($ei episodes) \r")
            end
            p_fit, fit, pbest, gbest, velocity_best, velocity = train_CFIM_noise(M, particles, p_fit, fit, max_episode, c0, c1, c2, particle_num, 
                                                                                        dim, pbest, gbest, velocity_best, velocity)
            append!(f_list, fit)
            SaveFile_state(f_list, gbest)
            print("\e[2K") 
            println("Iteration over, data saved.") 
            println("Final CFI is $fit")
        end
        
    else
        println("multiparameter scenario")
        println("search algorithm: Particle Swarm Optimization (PSO)")
        println("initial value of Tr(WF^{-1}) is $(f_ini)")
        fit = 0.0
        f_list = [f_ini]
        if save_file==true
            for ei in 1:(max_episode[1]-1)
                #### train ####
                p_fit, fit, pbest, gbest, velocity_best, velocity = train_CFIM_noise(M, particles, p_fit, fit, max_episode, c0, c1, c2, particle_num, 
                                                                                    dim, pbest, gbest, velocity_best, velocity)
                if ei%max_episode[2] == 0
                    pso.psi = [gbest[i] for i in 1:dim]
                    particles = repeat(pso, particle_num)
                end
                append!(f_list, (1.0/fit))
                SaveFile_state(f_list, gbest)
                print("current value of Tr(WF^{-1}) is $(1.0/fit) ($ei episodes) \r") 
            end
            p_fit, fit, pbest, gbest, velocity_best, velocity = train_CFIM_noise(M, particles, p_fit, fit, max_episode, c0, c1, c2, particle_num, 
                                                                                    dim, pbest, gbest, velocity_best, velocity)
            append!(f_list, (1.0/fit))
            SaveFile_state(f_list, gbest)
            print("\e[2K")
            println("Iteration over, data saved.")
            println("Final value of Tr(WF^{-1}) is $(1.0/fit)")
        else
            for ei in 1:(max_episode[1]-1)
                #### train ####
                p_fit, fit, pbest, gbest, velocity_best, velocity = train_CFIM_noise(M, particles, p_fit, fit, max_episode, c0, c1, c2, particle_num, 
                                                                                    dim, pbest, gbest, velocity_best, velocity)
                if ei%max_episode[2] == 0
                    pso.psi = [gbest[i] for i in 1:dim]
                    particles = repeat(pso, particle_num)
                end
                append!(f_list, (1.0/fit))
                print("current value of Tr(WF^{-1}) is $(1.0/fit) ($ei episodes) \r")
            end
            p_fit, fit, pbest, gbest, velocity_best, velocity = train_CFIM_noise(M, particles, p_fit, fit, max_episode, c0, c1, c2, particle_num, 
                                                                                    dim, pbest, gbest, velocity_best, velocity)
            append!(f_list, (1.0/fit))
            SaveFile_state(f_list, gbest)
            print("\e[2K") 
            println("Iteration over, data saved.") 
            println("Final value of Tr(WF^{-1}) is $(1.0/fit)")
        end
    end
end

function train_QFIM_noise(particles, p_fit, fit, max_episode, c0, c1, c2, particle_num, dim, pbest, gbest, velocity_best, velocity)
    for pj in 1:particle_num
        rho = particles[pj].psi*(particles[pj].psi)'
        F_tp = QFIM_TimeIndepend(particles[pj].freeHamiltonian, particles[pj].Hamiltonian_derivative, rho, particles[pj].decay_opt, 
                                 particles[pj].γ, particles[pj].tspan, particles[pj].accuracy)
        f_now = 1.0/real(tr(particles[pj].W*pinv(F_tp)))
        if f_now > p_fit[pj]
            p_fit[pj] = f_now
            for di in 1:dim
                pbest[di,pj] = particles[pj].psi[di]
            end
        end
    end

    for pj in 1:particle_num
        if p_fit[pj] > fit
            fit = p_fit[pj]
            for dj in 1:dim
                gbest[dj] = particles[pj].psi[dj]
                velocity_best[dj] = velocity[dj, pj]
            end
        end
    end

    for pk in 1:particle_num
        psi_pre = zeros(ComplexF64, dim)
        for dk in 1:dim
            psi_pre[dk] = particles[pk].psi[dk]
            velocity[dk, pk] = c0*velocity[dk, pk] + c1*rand()*(pbest[dk, pk] - particles[pk].psi[dk]) + c2*rand()*(gbest[dk] - particles[pk].psi[dk])
            particles[pk].psi[dk] = particles[pk].psi[dk] + velocity[dk, pk]
        end
        particles[pk].psi = particles[pk].psi/norm(particles[pk].psi)

        for dm in 1:dim
            velocity[dm, pk] = particles[pk].psi[dm] - psi_pre[dm]
        end
    end
    return p_fit, fit, pbest, gbest, velocity_best, velocity
end

function train_CFIM_noise(M, particles, p_fit, fit, max_episode, c0, c1, c2, particle_num, dim, pbest, gbest, velocity_best, velocity)
    for pj in 1:particle_num
        rho = particles[pj].psi*(particles[pj].psi)'
        F_tp = CFIM_TimeIndepend(M, particles[pj].freeHamiltonian, particles[pj].Hamiltonian_derivative, rho, particles[pj].decay_opt, 
                                 particles[pj].γ, particles[pj].tspan, particles[pj].accuracy)
        f_now = 1.0/real(tr(particles[pj].W*pinv(F_tp)))
        if f_now > p_fit[pj]
            p_fit[pj] = f_now
            for di in 1:dim
                pbest[di,pj] = particles[pj].psi[di]
            end
        end
    end

    for pj in 1:particle_num
        if p_fit[pj] > fit
            fit = p_fit[pj]
            for dj in 1:dim
                gbest[dj] = particles[pj].psi[dj]
                velocity_best[dj] = velocity[dj, pj]
            end
        end
    end

    for pk in 1:particle_num
        psi_pre = zeros(ComplexF64, dim)
        for dk in 1:dim
            psi_pre[dk] = particles[pk].psi[dk]
            velocity[dk, pk] = c0*velocity[dk, pk] + c1*rand()*(pbest[dk, pk] - particles[pk].psi[dk]) + c2*rand()*(gbest[dk] - particles[pk].psi[dk])
            particles[pk].psi[dk] = particles[pk].psi[dk] + velocity[dk, pk]
        end
        particles[pk].psi = particles[pk].psi/norm(particles[pk].psi)

        for dm in 1:dim
            velocity[dm, pk] = particles[pk].psi[dm] - psi_pre[dm]
        end
    end
    return p_fit, fit, pbest, gbest, velocity_best, velocity
end
