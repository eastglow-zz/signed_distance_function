#include "signed_distance_functionApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

template <>
InputParameters
validParams<signed_distance_functionApp>()
{
  InputParameters params = validParams<MooseApp>();
  return params;
}

signed_distance_functionApp::signed_distance_functionApp(InputParameters parameters) : MooseApp(parameters)
{
  signed_distance_functionApp::registerAll(_factory, _action_factory, _syntax);
}

signed_distance_functionApp::~signed_distance_functionApp() {}

void
signed_distance_functionApp::registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  ModulesApp::registerAll(f, af, s);
  Registry::registerObjectsTo(f, {"signed_distance_functionApp"});
  Registry::registerActionsTo(af, {"signed_distance_functionApp"});

  /* register custom execute flags, action syntax, etc. here */
}

void
signed_distance_functionApp::registerApps()
{
  registerApp(signed_distance_functionApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
signed_distance_functionApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  signed_distance_functionApp::registerAll(f, af, s);
}
extern "C" void
signed_distance_functionApp__registerApps()
{
  signed_distance_functionApp::registerApps();
}
