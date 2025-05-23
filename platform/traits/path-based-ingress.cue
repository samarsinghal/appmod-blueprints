"path-based-ingress": {
    annotations: {}
    attributes: {
        appliesToWorkloads: []
        conflictsWith: []
        podDisruptive:   false
        workloadRefPath: ""
    }
    description: "Ingress route trait."
    labels: {}
    type: "trait"
}

template: {
    parameter: {
        domain: string
        http: [string]: int
        class: *"nginx" | string
        rewritePath: *true | bool
        createService: *false | bool
    }

  // trait template can have multiple outputs in one trait
    outputs: {
        if parameter.createService {
            service: {
                apiVersion: "v1"
                kind:       "Service"
                metadata: name: context.name
                spec: {
                    selector: "app.oam.dev/component": context.name
                    ports: [
                        for k, v in parameter.http {
                            port:       v
                            targetPort: v
                        },
                    ]
                }
            }
        }
    }

    outputs: ingress: {
        apiVersion: "networking.k8s.io/v1"
        kind:       "Ingress"
        metadata: {
            name: context.name
            annotations: {
                "nginx.ingress.kubernetes.io/use-regex": "true"
                if parameter.rewritePath {
                    "nginx.ingress.kubernetes.io/rewrite-target": "/$2"
                }
            }
        }
        spec: {
            ingressClassName: parameter.class
            rules: [{
                host: parameter.domain
                http: {
                    paths: [
                        for k, v in parameter.http {
                            path: "\(k)(/|$)(.*)"
                            pathType: "ImplementationSpecific"
                            backend: {
                                service: {
                                    name: context.name
                                    port: number: v
                                }
                            }
                        },
                    ]
                }
            }]
        }
    }

    patch: {
        metadata: annotations: {
            "argocd.argoproj.io/compare-options": "IgnoreExtraneous"
            "argocd.argoproj.io/sync-options": "Prune=false"
        }
    }

    patchOutputs: {
        for k, v in context.outputs {
            "\(k)": {
                metadata: annotations: {
                    "argocd.argoproj.io/compare-options": "IgnoreExtraneous"
                    "argocd.argoproj.io/sync-options":    "Prune=false"
                }
            }
        }
        if parameter.createService {
            service: {
                metadata: annotations: {
                    "argocd.argoproj.io/compare-options": "IgnoreExtraneous"
                    "argocd.argoproj.io/sync-options": "Prune=false"
                }
            }
        }
        ingress: {
            metadata: annotations: {
                "argocd.argoproj.io/compare-options": "IgnoreExtraneous"
                "argocd.argoproj.io/sync-options": "Prune=false"
            }
        }

    }
}