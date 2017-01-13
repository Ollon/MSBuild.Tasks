//-----------------------------------------------------------------------
// <copyright file="ICodeGenerator.cs" company="Ollon, LLC">
//     Copyright (c) 2017 Ollon, LLC. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------

using System;

namespace MSBuild.Tasks.Tasks.Generator
{
    internal interface ICodeGenerator
    {
        void GenerateCode(CodeGenerationContext context);
    }
}