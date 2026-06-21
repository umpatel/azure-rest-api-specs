import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

import "./goal.tsp";
import "./recoveryPlans.tsp";
import "./drill.tsp";
import "./drillResource.tsp";
import "./drillRun.tsp";
import "./partnersolution.tsp";
import "./usagePlan.tsp";
import "./client.tsp";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.OpenAPI;

@armProviderNamespace("Microsoft.AzureResilienceManagement")
@versioned(Microsoft.AzureResilienceManagement.Versions)
namespace Microsoft.AzureResilienceManagement;

@doc("Microsoft.AzureResilienceManagement Resource Provider supported API versions.")
enum Versions {
  @doc("Microsoft.AzureResilienceManagement Resource Provider management API version 2025-02-01-preview.")
  @armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v6)
  v2025_02_01_preview: "2025-02-01-preview",

  @doc("Microsoft.AzureResilienceManagement Resource Provider management API version 2026-03-01-preview.")
  @armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v6)
  v2026_03_01_preview: "2026-03-01-preview",

  @doc("Microsoft.AzureResilienceManagement Resource Provider management API version 2026-04-01-preview.")
  @armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v6)
  v2026_04_01_preview: "2026-04-01-preview",
}

interface Operations extends Azure.ResourceManager.Operations {}

@armResourceOperations
interface OperationStatus {
  @doc("Returns the current status of an async operation.")
  @autoRoute
  get(
    ...ApiVersionParameter,

    @path
    @segment("providers")
    @doc("The provider namespace.")
    provider: "Microsoft.AzureResilienceManagement",

    ...LocationParameter,
    ...Azure.ResourceManager.Foundations.OperationIdParameter,
  ): ArmResponse<OperationStatusResult> | ErrorResponse;
}

@@segment(OperationStatus.get::parameters.operationId, "operationStatuses");

/** Represents a single permission entry for the resource provider. */
model ProviderPermission {
  @doc("The application ID of the application to which the permission belongs.")
  applicationId?: string;

  @doc("The role definition for the provider permission.")
  roleDefinition?: string;

  @doc("The managed by role definition for the provider permission.")
  managedByRoleDefinition?: string;
}

/** List of provider permissions. */
model ProviderPermissionListResult {
  @doc("The list of provider permissions for this RP.")
  @identifiers(#[])
  value: ProviderPermission[];

  @doc("The URL to get the next set of results.")
  nextLink?: string;
}

// Internal system operation — used by ARM to query permissions for this resource provider.
@armResourceOperations
interface ProviderPermissions {
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "x-ms-internal-operation is required to advertise system-only operations in the ARM operations list for KPI compliance."
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-operation" "ProviderPermissions is a custom provider-level route, not a standard ARM resource."
  @extension("x-ms-internal-operation", true)
  @autoRoute
  @get
  @doc("Gets the provider permissions for the Microsoft.AzureResilienceManagement resource provider.")
  list(
    ...ApiVersionParameter,

    @path
    @segment("providers")
    @doc("The provider namespace.")
    provider: "Microsoft.AzureResilienceManagement",
  ): ArmResponse<ProviderPermissionListResult> | ErrorResponse;
}

@@segment(ProviderPermissions.list::parameters.provider, "providerPermissions");
