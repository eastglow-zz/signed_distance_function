//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#ifndef SIGNED_DISTANCE_FUNCTIONTESTAPP_H
#define SIGNED_DISTANCE_FUNCTIONTESTAPP_H

#include "MooseApp.h"

class signed_distance_functionTestApp;

template <>
InputParameters validParams<signed_distance_functionTestApp>();

class signed_distance_functionTestApp : public MooseApp
{
public:
  signed_distance_functionTestApp(InputParameters parameters);
  virtual ~signed_distance_functionTestApp();

  static void registerApps();
  static void registerAll(Factory & f, ActionFactory & af, Syntax & s, bool use_test_objs = false);
};

#endif /* SIGNED_DISTANCE_FUNCTIONTESTAPP_H */
