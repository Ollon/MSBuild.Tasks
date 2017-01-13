//-----------------------------------------------------------------------
// <copyright file="CodeGeneratorFactory.cs" company="Ollon, LLC">
//     Copyright (c) 2017 Ollon, LLC. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------

using Microsoft.Build.Framework;
using Microsoft.Build.Utilities;
using System;

namespace MSBuild.Tasks.Tasks.Generator
{
    internal static class CodeGeneratorFactory
    {
        public static ICodeGenerator Create(TaskLoggingHelper logger, Language language)
        {
            switch (language)
            {
                case Language.Vsct:
                    return new CommandTableCodeGenerator(logger);
                case Language.CSharp:
                default:
                    return new CSharpCodeGenerator(logger);
            }
        }
    }
}