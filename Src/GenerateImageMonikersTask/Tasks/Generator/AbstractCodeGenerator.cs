//-----------------------------------------------------------------------
// <copyright file="AbstractCodeGenerator.cs" company="Ollon, LLC">
//     Copyright (c) 2017 Ollon, LLC. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------

using Microsoft.Build.Framework;
using Microsoft.Build.Utilities;
using System;

namespace MSBuild.Tasks.Tasks.Generator
{
    internal abstract class AbstractCodeGenerator : ICodeGenerator
    {
        protected TaskLoggingHelper Logger;
        public AbstractCodeGenerator(TaskLoggingHelper logger)
        {
            Logger = logger;
        }
        public void GenerateCode(CodeGenerationContext context)
        {



            GenerateCodeCore(context);
        }

        protected abstract void GenerateCodeCore(CodeGenerationContext context);
    }
}