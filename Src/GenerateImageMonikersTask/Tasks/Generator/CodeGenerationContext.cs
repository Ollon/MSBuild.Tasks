//-----------------------------------------------------------------------
// <copyright file="CodeGenerationContext.cs" company="Ollon, LLC">
//     Copyright (c) 2017 Ollon, LLC. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------

using System;

namespace MSBuild.Tasks.Tasks.Generator
{
    internal sealed class CodeGenerationContext
    {
        public CodeGenerationContext(
            ImageManifest imageManifestFile,
            string @namespace,
            string monikerClass,
            string monikerFile,
            string imageIdClass,
            string imageIdFile,
            string classAccess)
        {
            ImageManifest = imageManifestFile;
            Namespace = @namespace;
            MonikerClass = monikerClass;
            MonikerFile = monikerFile;
            ImageIdClass = imageIdClass;
            ImageIdFile = imageIdFile;
            ClassAccess = classAccess;
        }

        public ImageManifest ImageManifest { get; }
        public string Namespace { get; }
        public string MonikerClass { get; }
        public string MonikerFile { get; }
        public string ImageIdClass { get; }
        public string ImageIdFile { get; }
        public string ClassAccess { get; }
    }
}