{{/* standardize cloud provider */}}
{{- define "cloud_provider" -}}
  {{- if contains "eks" .Capabilities.KubeVersion.GitVersion -}}
    {{- print "eks" -}}
  {{- else if contains "gke" .Capabilities.KubeVersion.GitVersion -}}
    {{- print "gke" -}}
  {{- else if contains "azmk8s.io" .Values.clusterServer -}}
    {{- print "aks" -}}
  {{- else -}}
    {{- print "" -}}
  {{- end }}
{{- end }}

{{- define "account_guid" -}}
  {{- if .Values.kubescape.submit }}
    {{- if .Values.account -}}
    {{- else -}}
      {{- fail "submitting is enabled but value for account is not defined: please register at https://cloud.armosec.io to get yours and re-run with  --set account=<your Guid>" }}
    {{- end -}}
  {{- end }}
{{- end }}

{{- define "cluster_name" -}}
  {{- if .Values.kubescape.submit }}
    {{- if .Values.clusterName -}}
    {{- else -}}
      {{- fail "value for clusterName is not defined: re-run with  --set clusterName=<your cluster name>" }}
    {{- end -}}
  {{- end }}
{{- end }}

{{- define "components" -}}
gateway:
  enabled: {{ not (empty .Values.configurations.server.url) }}
hostScanner:
  enabled: {{ eq .Values.capabilities.nodeScan "enable" }}
kollector:
  enabled: {{ not (empty .Values.configurations.server.url) }}
kubescape:
  enabled: {{ or (eq .Values.capabilities.configurationScan "enable") (eq .Values.capabilities.nodeScan "enable") }}
kubescapeScheduler:
  enabled: {{ and (not (empty .Values.configurations.server.url)) (or (eq .Values.capabilities.configurationScan "enable") (eq .Values.capabilities.nodeScan "enable")) }}
kubevuln:
  enabled: {{ or (eq .Values.capabilities.relevancy "enable") (eq .Values.capabilities.vulnerabilityScan "enable") }}
kubevulnScheduler:
  enabled: {{ and (not (empty .Values.configurations.server.url)) (or (eq .Values.capabilities.relevancy "enable") (eq .Values.capabilities.vulnerabilityScan "enable")) }}
nodeAgent:
  enabled: {{ or (eq .Values.capabilities.relevancy "enable") (eq .Values.capabilities.networkGenerator "enable") (eq .Values.capabilities.seccomp "enable") (eq .Values.capabilities.runtimeObservability "enable") }}
operator:
  enabled: true
otelCollector:
  enabled: {{ eq .Values.capabilities.otel "enable" }}
storage:
  enabled: true
{{- end -}}
