//-----------------------------------------------------------------------
// <copyright file="CommandTableCodeGenerator.cs" company="Ollon, LLC">
//     Copyright (c) 2017 Ollon, LLC. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------

using System;
using Microsoft.Build.Framework;
using Microsoft.Build.Utilities;

namespace MSBuild.Tasks.Tasks.Generator
{
    internal sealed class CommandTableCodeGenerator : AbstractCodeGenerator
    {
        public CommandTableCodeGenerator(TaskLoggingHelper logger) : base(logger)
        {
        }

        protected override void GenerateCodeCore(CodeGenerationContext context)
        {

        }
    }
}