interwidth_rlx = 0.28
interwidth1 = 0.28 #Target full-interfacial Width (in mm) - 12-element-width
interwidth2 = 0.24 #Target full-interfacial Width (in mm) - 10-element-width
interwidth3 = 0.20 #Target full-interfacial Width (in mm) - 8-element-width
interwidth4 = 0.16 #Target full-interfacial Width (in mm) - 6-element-width
interwidth5 = 0.12 #Target full-interfacial Width (in mm) - 5-element-width

pi = 3.141592
eps = 0.0001
delta = 0.05
rlx_time = 0.1
calc_time = 0.19

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 192
  ny = 128
  xmax = 7.68      
  ymax = 5.12    
  #type = FileMesh
  elem_type = QUAD4
[]

[Variables]
  [./dist_zero]
    order = FIRST
    family = LAGRANGE
  [../]

  [./dist]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[AuxVariables]
  [./ddist_x]
    order = FIRST
    family = MONOMIAL
  [../]
  [./ddist_y]
    order = FIRST
    family = MONOMIAL
  [../]
  [./time]
  [../]
  [./peq_IW1]
    order = FIRST
    family = MONOMIAL
  [../]
  [./peq_IW2]
    order = FIRST
    family = MONOMIAL
  [../]
  [./peq_IW3]
    order = FIRST
    family = MONOMIAL
  [../]
  [./peq_IW4]
    order = FIRST
    family = MONOMIAL
  [../]
  [./peq_IW5]
    order = FIRST
    family = MONOMIAL
  [../]
[]

[ICs]
  [./Image_dist_zero]
    type = FunctionIC
    variable = dist_zero
    function = bilevel
  [../]
  [./Image_dist]
    type = FunctionIC
    variable = dist
    function = bilevel_dist
  [../]
[]

[Functions]
  [./boxcar_from_image]  # range: [0, 1]
    type = ImageFunction
    file = './imageIC_2D/boxcar.png'
    #file = './imageIC_2D/Picture1.png'
    #file = './imageIC_2D/Picture2.png'
    component = 0
    scale = 0.00392156862
  [../]
  [./One]
    type = ParsedFunction
    value = 1
  [../]
  [./bilevel]  # rescaling the range of bilevel data value from [0,1] to [-1,1]
    type = LinearCombinationFunction
    functions = 'One boxcar_from_image'
    w =         '-1  2'
  [../]
  [./bilevel_dist]
    type = LinearCombinationFunction
    functions = 'bilevel'
    w =         '${delta}'
  [../]
[]

[AuxKernels]
  [./time]
    type = FunctionAux
    variable = time
    function = t
  [../]
  [./get_dpx]
    type = VariableGradientComponent
    variable = ddist_x
    gradient_variable = dist
    component = x
    execute_on = LINEAR
  [../]
  [./get_dpy]
    type = VariableGradientComponent
    variable = ddist_y
    gradient_variable = dist
    component = y
    execute_on = LINEAR
  [../]
  [./Equil_p_IW1]
    type = MaterialRealAux
    variable = peq_IW1
    property = equil_phi_IW1
  [../]
  [./Equil_p_IW2]
    type = MaterialRealAux
    variable = peq_IW2
    property = equil_phi_IW2
  [../]
  [./Equil_p_IW3]
    type = MaterialRealAux
    variable = peq_IW3
    property = equil_phi_IW3
  [../]
  [./Equil_p_IW4]
    type = MaterialRealAux
    variable = peq_IW4
    property = equil_phi_IW4
  [../]
  [./Equil_p_IW5]
    type = MaterialRealAux
    variable = peq_IW5
    property = equil_phi_IW5
  [../]

[]

[Kernels]
  [./TimeDerivative_dist_zero]
    type = TimeDerivative
    variable = dist_zero
  [../]

  [./TimeDerivative_dist]
    type = TimeDerivative
    variable = dist
  [../]

  [./dist_function]
    type = DistanceFunction
    variable = dist
    bilevel_data = dist_zero
    mob_name = Lop
    epsilon = 0.0001
  [../]

  [./smoothing]
    type = ACInterface
    variable = dist
    kappa_name = diffuse_parameter
    mob_name = Lop
  [../]

  [./dist_ACsmoothing_grad]
    type = ACInterface
    variable = dist
    kappa_name = kappa_VS_ACsmoothing
    mob_name = Mop
  [../]
  [./dist_ACsmoothing_dw]
    type = AllenCahn
    variable = dist
    f_name = fVS_ACsmoothing
    mob_name = Mop
  [../]

  [./dist_zero_ACsmoothing_grad]
    type = ACInterface
    variable = dist_zero
    kappa_name = kappa_VS_ACsmoothing
    mob_name = Mop
  [../]
  [./dist_zero_ACsmoothing_dw]
    type = AllenCahn
    variable = dist_zero
    f_name = fVS_ACsmoothing_d0
    mob_name = Mop
  [../]

[]

[Materials]
  [./diffuse_param]
    type = GenericConstantMaterial
    prop_names = 'L diffuse_parameter M'
    prop_values = '1  0.005            1e5'
  [../]
  [./Lop]
    type = ParsedMaterial
    f_name = Lop
    material_property_names = 'L'
    args = 'time'
    function = 'if(time >= -${calc_time}, L, 0)'
  []
  [./Mop]
    type = ParsedMaterial
    f_name = Mop
    material_property_names = 'M'
    args = 'time'
    function = 'if(time < -${calc_time}, M, 0)'
  []
  [./sigop_VS]
    type = ParsedMaterial
    f_name = sigop_VS
    args = 'time'
    material_property_names = 'sig_VS'
    function = 'if(time < -${calc_time}, 0.01e-4, sig_VS)'
  [../]
  [./dwh_VS]
    type = ParsedMaterial
    f_name = dwh_VS
    material_property_names = 'sigop_VS'
    function = '4*sigop_VS/${interwidth_rlx}'
  [../]
  [./kappa_VS_ACsmoothing]
    type = ParsedMaterial
    f_name = kappa_VS_ACsmoothing
    material_property_names = 'sigop_VS'
    function = '2*sigop_VS*4*${interwidth_rlx}/(${pi})^2'
  [../]
  [./doublewell_ACsmoothing]
    type = DerivativeParsedMaterial
    f_name = fVS_ACsmoothing
    material_property_names = 'dwh_VS ABScS(dist) ABScV(dist)'
    args = 'dist'
    # function = '0.5*dwh_VS*(sqrt((1-cS)^2+(${eps})^2)-${eps})*(sqrt(cS^2+(${eps})^2)-${eps})'
    function = '2*dwh_VS*ABScV*ABScS*${delta}'
    derivative_order = 2
  [../]
  [./abs_cV]
    type = DerivativeParsedMaterial
    f_name = ABScV
    args = 'dist'
    # function = '(sqrt(cV^2 + (${eps})^2) - ${eps})/3/(sqrt(1./9/. + (${eps})^2) - ${eps})'
    function = 'if(${delta}-dist >= 0, ${delta}-dist, 0.5*(${delta}-dist)*(${delta}-dist + 2*${eps})/${eps})'
    derivative_order = 2
  [../]
  [./abs_cS]
    type = DerivativeParsedMaterial
    f_name = ABScS
    args = 'dist'
    # function = '(sqrt(cS^2 + (${eps})^2) - ${eps})/3/(sqrt(1./9. + (${eps})^2) - ${eps})'
    # function = 'if(1+dist >= 0, 1+dist, 0.5*(1+dist)*(1+dist + 2*${eps})/${eps})'
    function = 'if(${delta}+dist >= 0, ${delta}+dist, 0.5*(${delta}+dist)*(${delta}+dist + 2*${eps})/${eps})'
    derivative_order = 2
  [../]

  [./d0_doublewell_ACsmoothing]
    type = DerivativeParsedMaterial
    f_name = fVS_ACsmoothing_d0
    material_property_names = 'dwh_VS ABScS_d0(dist_zero) ABScV_d0(dist_zero)'
    args = 'dist_zero'
    # function = '0.5*dwh_VS*(sqrt((1-cS)^2+(${eps})^2)-${eps})*(sqrt(cS^2+(${eps})^2)-${eps})'
    function = '2*dwh_VS*ABScV_d0*ABScS_d0'
    derivative_order = 2
  [../]
  [./d0_abs_cV]
    type = DerivativeParsedMaterial
    f_name = ABScV_d0
    args = 'dist_zero'
    # function = '(sqrt(cV^2 + (${eps})^2) - ${eps})/3/(sqrt(1./9/. + (${eps})^2) - ${eps})'
    function = 'if(1-dist_zero >= 0, 1-dist_zero, 0.5*(1-dist_zero)*(1-dist_zero + 2*${eps})/${eps})'
    derivative_order = 2
  [../]
  [./d0_abs_cS]
    type = DerivativeParsedMaterial
    f_name = ABScS_d0
    args = 'dist_zero'
    # function = '(sqrt(cS^2 + (${eps})^2) - ${eps})/3/(sqrt(1./9. + (${eps})^2) - ${eps})'
    # function = 'if(1+dist >= 0, 1+dist, 0.5*(1+dist)*(1+dist + 2*${eps})/${eps})'
    function = 'if(1+dist_zero >= 0, 1+dist_zero, 0.5*(1+dist_zero)*(1+dist_zero + 2*${eps})/${eps})'
    derivative_order = 2
  [../]

  [./Equil_phi_IW1]
    type = ParsedMaterial
    f_name = equil_phi_IW1
    args = 'dist'
    function = 'if(dist > ${interwidth1}/2 , 1 , if(dist <= ${interwidth1}/2, if(dist >= -${interwidth1}/2, 0.5+0.5*sin(${pi}*(dist)/${interwidth1}), 0), 0))'
    outputs = exodus
  [../]

  [./Equil_phi_IW2]
    type = ParsedMaterial
    f_name = equil_phi_IW2
    args = 'dist'
    function = 'if(dist > ${interwidth2}/2 , 1 , if(dist <= ${interwidth2}/2, if(dist >= -${interwidth2}/2, 0.5+0.5*sin(${pi}*(dist)/${interwidth2}), 0), 0))'
    outputs = exodus
  [../]

  [./Equil_phi_IW3]
    type = ParsedMaterial
    f_name = equil_phi_IW3
    args = 'dist'
    function = 'if(dist > ${interwidth3}/2 , 1 , if(dist <= ${interwidth3}/2, if(dist >= -${interwidth3}/2, 0.5+0.5*sin(${pi}*(dist)/${interwidth3}), 0), 0))'
    outputs = exodus
  [../]

  [./Equil_phi_IW4]
    type = ParsedMaterial
    f_name = equil_phi_IW4
    args = 'dist'
    function = 'if(dist > ${interwidth4}/2 , 1 , if(dist <= ${interwidth4}/2, if(dist >= -${interwidth4}/2, 0.5+0.5*sin(${pi}*(dist)/${interwidth4}), 0), 0))'
    outputs = exodus
  [../]

  [./Equil_phi_IW5]
    type = ParsedMaterial
    f_name = equil_phi_IW5
    args = 'dist'
    function = 'if(dist > ${interwidth5}/2 , 1 , if(dist <= ${interwidth5}/2, if(dist >= -${interwidth5}/2, 0.5+0.5*sin(${pi}*(dist)/${interwidth5}), 0), 0))'
    outputs = exodus
  [../]
[]

[Preconditioning]
  #active = ''
  [./cw_coupling]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  scheme = bdf2
  l_max_its = 30
  l_tol = 1e-6
  nl_max_its = 20
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-11

  # petsc_options_iname = '-pc_type -sub_pc_type'
  # petsc_options_value = 'asm      lu          '
  # petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  # petsc_options_value = 'lu superlu_dist'
  petsc_options_iname = '-pc_type -ksp_type'
  petsc_options_value = 'bjacobi  bcgs'

  dt = 0.01
  dtmax = 0.01

  # [./Adaptivity]
  #   initial_adaptivity = 5
  #   max_h_level = 5
  #   refine_fraction = 0.99
  #   coarsen_fraction = 0.001
  #   weight_names =  'dist'
  #   weight_values = '1'
  # [../]
  start_time = -0.19  # -(rlx_time + calc_time)
  end_time = 0.0
[]

[Outputs]
  exodus = true
  file_base = 2Dori
  sync_times = '-0.19 0' # '-calc_time 0'
[]
